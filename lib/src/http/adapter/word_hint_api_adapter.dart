// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:duolingo4d/duolingo4d.dart';

// Project imports:
import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/const/error_type.dart';
import 'package:duo_tracker/src/http/const/from_api.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/word_hint_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';

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

    try {
      final response = await Duolingo.instance.wordHint(
        fromLanguage: params['fromLanguage'],
        learningLanguage: params['learningLanguage'],
        sentence: params['sentence'],
      );

      if (response.status.isOk) {
        final hintsMatrix = _createHintsMatrix(
          response: response,
        );

        if (hintsMatrix.isEmpty) {
          return ApiResponse.from(
            fromApi: FromApi.wordHint,
            errorType: ErrorType.noHintData,
          );
        }

        await _refreshWordHints(
          params: params,
          hintsMatrix: hintsMatrix,
        );

        return ApiResponse.from(
          fromApi: FromApi.wordHint,
          errorType: ErrorType.none,
        );
      } else if (response.status.isClientError) {
        return ApiResponse.from(
          fromApi: FromApi.wordHint,
          errorType: ErrorType.client,
        );
      } else if (response.status.isServerError) {
        return ApiResponse.from(
          fromApi: FromApi.wordHint,
          errorType: ErrorType.server,
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.unknown,
      );
    } catch (e) {
      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.unknown,
      );
    }
  }

  Map<String, List<String>> _createHintsMatrix({
    required WordHintResponse response,
  }) {
    final hintsMatrix = <String, List<String>>{};

    for (final token in response.tokens) {
      for (final row in token.table.rows) {
        final cells = row.cells;
        for (final cell in cells) {
          final int colspan = cell.span;
          final String key = colspan > 0
              ? _fetchWordString(token: token).substring(0, colspan)
              : token.value;

          if (hintsMatrix.containsKey(key)) {
            final List<String> hintsInternal = hintsMatrix[key]!;
            final String hint = cell.hint;

            if (!hintsInternal.contains(hint)) {
              hintsInternal.add(hint);
            }
          } else {
            hintsMatrix[key] = [cell.hint];
          }
        }
      }
    }

    return hintsMatrix;
  }

  String _fetchWordString({
    required HintToken token,
  }) {
    final hintTable = token.table;

    if (hintTable.headers.isEmpty) {
      return token.value;
    }

    String wordString = '';
    for (final header in hintTable.headers) {
      wordString += header.token;
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

    final formalLearningLanguage = LanguageConverter.toFormalLanguageCode(
      languageCode: learningLanguage,
    );
    final formalFromLanguage = LanguageConverter.toFormalLanguageCode(
      languageCode: fromLanguage,
    );

    // Refresh word hint based on word id and user id
    await _wordHintService.deleteByWordIdAndUserId(
      wordId,
      userId,
    );

    final now = DateTime.now();
    hintsMatrix.forEach(
      (final value, final hints) {
        for (final hint in hints) {
          _wordHintService.insert(
            WordHint.from(
              wordId: wordId,
              userId: userId,
              learningLanguage: learningLanguage,
              fromLanguage: fromLanguage,
              formalLearningLanguage: formalLearningLanguage,
              formalFromLanguage: formalFromLanguage,
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
