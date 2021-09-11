// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:duo_tracker/src/component/dialog/alert_dialog.dart';
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/repository/service/word_hint_service.dart';
import 'package:duo_tracker/src/security/encryption.dart';
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
        return _LearnedWordApiAdapter();
    }
  }

  Future<void> execute({
    required final BuildContext context,
    final params = const <String, String>{},
    final fromDialog = false,
  });
}

abstract class _ApiAdapter implements ApiAdapter {
  @override
  Future<void> execute({
    required final BuildContext context,
    final params = const <String, String>{},
    final fromDialog = false,
  }) async {
    if (!await _Network.isConnected()) {
      await _checkResponse(
        context: context,
        response: ApiResponse.from(
          fromApi: FromApi.none,
          errorType: ErrorType.network,
          message:
              'Could not detect a valid network. Please check the network environment and the network settings of the device.',
        ),
        fromDialog: fromDialog,
      );
    }

    await _checkResponse(
      context: context,
      response: await doExecute(
        context: context,
        params: params,
      ),
      fromDialog: fromDialog,
    );
  }

  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  });

  Future<void> _checkResponse({
    required final BuildContext context,
    required ApiResponse response,
    required bool fromDialog,
  }) async {
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
        await OpenSettings.openNetworkOperatorSetting();
        break;
      case ErrorType.noUserRegistered:
        await showAuthDialog(
          context: context,
          barrierDismissible: false,
        );
        break;
      case ErrorType.authentication:
        await showAlertDialog(
            context: context,
            title: 'Authentication failure',
            content: response.message);
        break;
      case ErrorType.client:
        await showAlertDialog(
          context: context,
          title: 'Client error',
          content: response.message.isEmpty
              ? 'An error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );
        break;
      case ErrorType.server:
        await showAlertDialog(
          context: context,
          title: 'Server error',
          content: response.message.isEmpty
              ? 'A server error occurred while communicating with the Duolingo API. Please try again later.'
              : response.message,
        );
        break;
      case ErrorType.unknown:
        await showAlertDialog(
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
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    final username = await CommonSharedPreferencesKey.username.getString();
    final password = await CommonSharedPreferencesKey.password.getString();

    if (username.isEmpty || password.isEmpty) {
      /// Enter this block at first time
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.noUserRegistered,
      );
    }

    final response = await Api.login.request.send(
      params: {
        'login': username,
        'password': Encryption.decode(
          value: password,
        ),
      },
    );

    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      if (jsonMap.containsKey('failure')) {
        return ApiResponse.from(
            fromApi: FromApi.login,
            errorType: ErrorType.authentication,
            message: 'The username or password was wrong.');
      } else {
        await CommonSharedPreferencesKey.userId.setString(jsonMap['user_id']);

        // Update user information
        await _UserApiAdapter().execute(context: context);

        return ApiResponse.from(
          fromApi: FromApi.login,
          errorType: ErrorType.none,
          message: 'Your account has been authenticated.',
        );
      }
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.login,
      errorType: ErrorType.unknown,
    );
  }
}

class _UserApiAdapter extends _ApiAdapter {
  @override
  Future<ApiResponse> doExecute({
    required BuildContext context,
    final params = const <String, String>{},
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final response = await Api.user.request.send(params: {'userId': userId});
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      // final jsonMap = jsonDecode(response.body);

      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.user,
      errorType: ErrorType.unknown,
    );
  }
}

class _LearnedWordApiAdapter extends _ApiAdapter {
  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    final response = await Api.learnedWord.request.send();
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(response.body);
      final String languageString = jsonMap['language_string'];
      final String learningLanguage = jsonMap['learning_language'];
      final String fromLanguage = jsonMap['from_language'];

      final userId = await CommonSharedPreferencesKey.userId.getString();

      for (final Map<String, dynamic> overview in jsonMap['vocab_overview']) {
        final String wordId = overview['id'];
        final String wordString = overview['word_string'];

        await _learnedWordService.replaceById(
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
            wordString: wordString,
            normalizedString: overview['normalized_string'] ?? '',
            pos: overview['pos'] ?? '',
            lastPracticedMs: overview['last_practiced_ms'] ?? -1,
            skill: overview['skill'] ?? '',
            lastPracticed: overview['last_practiced'] ?? '',
            strength: overview['strength'] ?? 0.0,
            skillUrlTitle: overview['skill_url_title'] ?? '',
            gender: overview['gender'] ?? '',
            bookmarked: false,
            completed: false,
            deleted: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Update word hint based on word id
        _WordHintApiAdapter().execute(
          context: context,
          params: {
            'wordId': wordId,
            'userId': userId,
            'learningLanguage': learningLanguage,
            'fromLanguage': fromLanguage,
            'sentence': wordString,
          },
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.learnedWord,
      errorType: ErrorType.unknown,
    );
  }
}

class _WordHintApiAdapter extends _ApiAdapter {
  /// The required parameter for word id
  static const _paramWordId = 'wordId';

  /// The word hint service
  final _wordHintService = WordHintService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    if (!params.containsKey(_paramWordId)) {
      throw FlutterError('The parameter "$_paramWordId" is required.');
    }

    final response = await Api.wordHint.request.send(params: params);
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final hintsMatrix = _createHintsMatrix(
        json: jsonDecode(response.body),
      );

      await _refreshWordHints(
        params: params,
        hintsMatrix: hintsMatrix,
      );

      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.wordHint,
      errorType: ErrorType.unknown,
    );
  }

  Map<String, List<String>> _createHintsMatrix({
    required Map<String, dynamic> json,
  }) {
    final hintsMatrix = <String, List<String>>{};

    String wordString = '';
    int colspan = -1;

    for (final Map<String, dynamic> token in json['tokens']) {
      if (token['hint_table'] == null) {
        continue;
      }

      wordString = _fetchWordString(token: token);

      final hintTable = token['hint_table'];
      final hints = <String>[];

      for (final Map<String, dynamic> row in hintTable['rows']) {
        for (final Map<String, dynamic> cell in row['cells']) {
          if (cell.isNotEmpty) {
            hints.add(cell['hint']);
            colspan = cell['colspan'] ?? -1;
          }
        }
      }

      String key = colspan <= 0 ? wordString : wordString.substring(0, colspan);
      colspan = -1;

      if (hintsMatrix.containsKey(key)) {
        // Merge hints to matrix
        final List<String> hintsInternal = hintsMatrix[key]!;

        for (String hint in hints) {
          if (!hintsInternal.contains(hint)) {
            hintsInternal.add(hint);
          }
        }
      } else {
        hintsMatrix[key] = hints;
      }
    }

    return hintsMatrix;
  }

  String _fetchWordString({
    required Map<String, dynamic> token,
  }) {
    final hintTable = token['hint_table'];

    if (!hintTable.containsKey('headers')) {
      return token['value'];
    }

    String wordString = '';

    for (final Map<String, dynamic> header in hintTable['headers']) {
      wordString += header['token'];
    }

    return wordString;
  }

  Future<void> _refreshWordHints({
    required Map<String, String> params,
    required Map<String, List<String>> hintsMatrix,
  }) async {
    final wordId = params[_paramWordId]!;
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final learningLanguage = params['learningLanguage']!;
    final fromLanguage = params['fromLanguage']!;

    // Refresh word hint based on word id and user id
    await _wordHintService.deleteByWordIdAndUserId(
      wordId,
      userId,
    );

    hintsMatrix.forEach(
      (String value, List<String> hints) {
        for (var hint in hints) {
          _wordHintService.insert(
            WordHint.from(
              wordId: wordId,
              userId: userId,
              learningLanguage: learningLanguage,
              fromLanguage: fromLanguage,
              value: value,
              hint: hint,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
      },
    );
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
    connectivity ??= await (Connectivity().checkConnectivity());

    return connectivity == ConnectivityResult.mobile;
  }

  static Future<bool> _isWifiConnected({
    ConnectivityResult? connectivity,
  }) async {
    connectivity ??= await (Connectivity().checkConnectivity());

    return connectivity == ConnectivityResult.wifi;
  }
}

class _HttpStatus {
  /// Returns the new instance of [_HttpStatus] based on [code] passed as an argument.
  _HttpStatus.from({
    required this.code,
  });

  /// The status code
  final int code;

  bool get isAccepted => code == 200;

  bool get isClientError => 400 <= code && code < 500;

  bool get isServerError => 500 <= code && code < 600;
}
