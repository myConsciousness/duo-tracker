// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:duovoc/src/component/dialog/alert_dialog.dart';
import 'package:duovoc/src/component/snackbar/info_snack_bar.dart';
import 'package:duovoc/src/http/api_response.dart';
import 'package:duovoc/src/http/duolingo_api.dart';
import 'package:duovoc/src/preference/common_shared_preferences_key.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/service/learned_word_service.dart';
import 'package:duovoc/src/security/encryption.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

/// The enum that manages API adapter type.
enum ApiAdapterType {
  login,
  overview,
}

abstract class ApiAdapter {
  /// Returns API adapter linked to the [type] passed as an argument.
  factory ApiAdapter.of({
    required ApiAdapterType type,
  }) {
    switch (type) {
      case ApiAdapterType.login:
        return _LoginApiAdapter();
      case ApiAdapterType.overview:
        return _OverviewApiAdapter();
    }
  }

  Future<void> execute({
    required final BuildContext context,
    final params = const <String, String>{},
    final fromDialog = false,
  });
}

abstract class _ApiAdapter implements ApiAdapter {
  Future<ApiResponse> doExecute({
    final params = const <String, String>{},
  });

  @override
  Future<void> execute({
    required final BuildContext context,
    final params = const <String, String>{},
    final fromDialog = false,
  }) async {
    if (!await _Network.isConnected()) {
      this._checkResponse(
        context: context,
        response: ApiResponse.from(
          errorType: ErrorType.network,
          message:
              'Could not detect a valid network. Please check the network environment and the network settings of the device.',
        ),
        fromDialog: fromDialog,
      );
    }

    this._checkResponse(
      context: context,
      response: await this.doExecute(params: params),
      fromDialog: fromDialog,
    );
  }

  void _checkResponse({
    required final BuildContext context,
    required ApiResponse response,
    required bool fromDialog,
  }) {
    switch (response.errorType) {
      case ErrorType.none:
        if (response.message.isNotEmpty) {
          InfoSnackbar.from(context: context).show(
            content: response.message,
          );
        }

        if (fromDialog) {
          Navigator.pop(context);
        }

        break;
      case ErrorType.network:
        OpenSettings.openNetworkOperatorSetting();
        break;
      case ErrorType.authentication:
        showAlertDialog(
            context: context,
            title: 'Authentication failure',
            content: response.message);
        break;
      case ErrorType.client:
        showAlertDialog(
          context: context,
          title: 'Client error',
          content: response.message.isEmpty
              ? 'An error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );
        break;
      case ErrorType.server:
        showAlertDialog(
          context: context,
          title: 'Server error',
          content: response.message.isEmpty
              ? 'A server error occurred while communicating with the Duolingo API. Please try again later.'
              : response.message,
        );
        break;
      case ErrorType.unknown:
        showAlertDialog(
          context: context,
          title: 'Unknown error',
          content: response.message.isEmpty
              ? 'An unknown error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );
        break;
    }
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
        return ApiResponse.from(
            errorType: ErrorType.authentication,
            message: 'The username or password was wrong.');
      } else {
        CommonSharedPreferencesKey.username.setString(jsonMap['username']);
        CommonSharedPreferencesKey.userId.setString(jsonMap['user_id']);
        CommonSharedPreferencesKey.password
            .setString(Encryption.encode(value: params['password']));
        return ApiResponse.from(
          errorType: ErrorType.none,
          message: 'Your account has been authenticated.',
        );
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
    final response = await Api.learnedWord.request.send();
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(response.body);
      final languageString = jsonMap['language_string'];
      final learningLanguage = jsonMap['learning_language'];
      final fromLanguage = jsonMap['from_language'];

      final userId = await CommonSharedPreferencesKey.userId.getString();

      for (final Map<String, dynamic> overview in jsonMap['vocab_overview']) {
        await this._learnedWordService.replaceByWordId(
              LearnedWord.from(
                wordId: overview['id'],
                userId: userId,
                languageString: languageString,
                learningLanguage: learningLanguage,
                fromLanguage: fromLanguage,
                lexemeId: overview['lexeme_id'] ?? '',
                relatedLexemes: overview['related_lexemes'],
                strengthBars: overview['strength_bars'] ?? -1,
                infinitive: overview['infinitive'] ?? '',
                wordString: overview['word_string'] ?? '',
                normalizedString: overview['normalized_string'] ?? '',
                pos: overview['pos'] ?? '',
                lastPracticedMs: overview['last_practiced_ms'] ?? -1,
                skill: overview['skill'] ?? '',
                lastPracticed: overview['last_practiced'] ?? '',
                strength: overview['strength'] ?? 0.0,
                skillUrlTitle: overview['skill_url_title'] ?? '',
                gender: overview['gender'] ?? '',
                bookmarked: false,
                deleted: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
      }

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
