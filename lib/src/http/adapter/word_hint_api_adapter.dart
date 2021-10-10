// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/http_status.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/word_hint_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';

class WordHintApiAdapter extends ApiAdapter {
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

    final response = await DuolingoApi.wordHint.request.send(params: params);
    final httpStatus = HttpStatus.from(code: response.statusCode);

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

    for (final Map<String, dynamic> token in json['tokens']) {
      if (token['hint_table'] == null) {
        continue;
      }

      for (final Map<String, dynamic> row in token['hint_table']['rows']) {
        for (final Map<String, dynamic> cell in row['cells']) {
          if (cell.isNotEmpty) {
            final int colspan = cell['colspan'] ?? -1;
            final String key = colspan > 0
                ? _fetchWordString(token: token).substring(0, colspan)
                : token['value'];

            if (hintsMatrix.containsKey(key)) {
              final List<String> hintsInternal = hintsMatrix[key]!;
              final String hint = cell['hint'];

              if (!hintsInternal.contains(hint)) {
                hintsInternal.add(hint);
              }
            } else {
              hintsMatrix[key] = [cell['hint']];
            }
          }
        }
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

    final now = DateTime.now();
    hintsMatrix.forEach(
      (final String value, final List<String> hints) {
        for (final String hint in hints) {
          _wordHintService.insert(
            WordHint.from(
              wordId: wordId,
              userId: userId,
              learningLanguage: learningLanguage,
              fromLanguage: fromLanguage,
              formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
                languageCode: learningLanguage,
              ),
              formalFromLanguage: LanguageConverter.toFormalLanguageCode(
                languageCode: fromLanguage,
              ),
              value: value,
              hint: hint,
              createdAt: now,
              updatedAt: now,
            ),
          );
        }
      },
    );
  }
}
