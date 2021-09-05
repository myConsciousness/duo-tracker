// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:duovoc/src/http/api_response.dart';
import 'package:duovoc/src/http/duolingo_api.dart';
import 'package:duovoc/src/preference/common_shared_preferences_key.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/service/learned_word_service.dart';

/// The enum that manages API adapter type.
enum ApiAdapterType {
  login,
  overview,
}

abstract class Adapter {
  /// Returns API adapter linked to the [type] passed as an argument.
  factory Adapter.of({
    required ApiAdapterType type,
  }) {
    switch (type) {
      case ApiAdapterType.login:
        return _LoginApiAdapter();
      case ApiAdapterType.overview:
        return _OverviewApiAdapter();
    }
  }

  Future<ApiResponse> execute({
    final params = const <String, String>{},
  });
}

abstract class _ApiAdapter implements Adapter {
  Future<ApiResponse> doExecute({
    final params = const <String, String>{},
  });

  @override
  Future<ApiResponse> execute({
    final params = const <String, String>{},
  }) async {
    if (!await _Network.isConnected()) {
      return ApiResponse.from(
        errorType: ErrorType.network,
      );
    }

    return await this.doExecute();
  }
}

class _LoginApiAdapter extends _ApiAdapter {
  @override
  Future<ApiResponse> doExecute({
    final params = const <String, String>{},
  }) async {
    final response = await Api.login.request.send(params: params);
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      if (jsonMap.containsKey('failure')) {
        final failedReason = jsonMap['failure'];

        if (failedReason == 'user_does_not_exist') {
          return ApiResponse.from(errorType: ErrorType.username);
        } else {
          return ApiResponse.from(errorType: ErrorType.password);
        }
      } else {
        CommonSharedPreferencesKey.username.setString(jsonMap['username']);
        CommonSharedPreferencesKey.userId.setString(jsonMap['user_id']);
        CommonSharedPreferencesKey.password.setString(params['password']);
        return ApiResponse.from(errorType: ErrorType.none);
      }
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(errorType: ErrorType.client);
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(errorType: ErrorType.server);
    }

    return ApiResponse.from(errorType: ErrorType.unknown);
  }
}

class _OverviewApiAdapter extends _ApiAdapter {
  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    final params = const <String, String>{},
  }) async {
    final response = await Api.overview.request.send();
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(response.body);
      final languageString = jsonMap['language_string'];
      final learningLanguage = jsonMap['learning_language'];
      final fromLanguage = jsonMap['from_language'];

      jsonMap['vocab_overview'].forEach(
        (overview) {
          this._learnedWordService.replaceByWordId(
                LearnedWord.from(
                  wordId: overview['word'],
                  userId: 10010,
                  languageString: languageString,
                  learningLanguage: learningLanguage,
                  fromLanguage: fromLanguage,
                  lexemeId: overview['lexeme_id'],
                  relatedLexemes: overview['related_lexemes'],
                  strengthBars: overview['strength_bars'],
                  infinitive: overview['infinitive'],
                  wordString: overview['word_string'],
                  normalizedString: overview['normalized_string'],
                  pos: overview['pos'],
                  lastPracticedMs: overview['last_practiced_ms'],
                  skill: overview['skill'],
                  lastPracticed: overview['last_practiced'],
                  strength: overview['strength'],
                  skillUrlTitle: overview['skill_url_title'],
                  gender: overview['gender'],
                  bookmarked: false,
                  deleted: false,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
        },
      );

      return ApiResponse.from(errorType: ErrorType.none);
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(errorType: ErrorType.client);
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(errorType: ErrorType.server);
    }
    return ApiResponse.from(errorType: ErrorType.unknown);
  }
}

class _Network {
  static Future<bool> isConnected() async {
    final connectivity = await (Connectivity().checkConnectivity());
    return await _isMobileConnected(connectivity: connectivity) ||
        await _isWifiConnected(connectivity: connectivity);
  }

  static Future<bool> _isMobileConnected({
    ConnectivityResult? connectivity,
  }) async {
    if (connectivity == null) {
      connectivity = await (Connectivity().checkConnectivity());
    }

    return connectivity == ConnectivityResult.mobile;
  }

  static Future<bool> _isWifiConnected({
    ConnectivityResult? connectivity,
  }) async {
    if (connectivity == null) {
      connectivity = await (Connectivity().checkConnectivity());
    }

    return connectivity == ConnectivityResult.wifi;
  }
}

class _HttpStatus {
  /// The status code
  final int code;

  /// Returns the new instance of [_HttpStatus] based on [code] passed as an argument.
  _HttpStatus.from({
    required this.code,
  });

  bool get isAccepted => this.code == 200;
  bool get isClientError => 400 <= this.code && this.code < 500;
  bool get isServerError => 500 <= this.code && this.code < 600;
}
