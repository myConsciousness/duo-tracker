// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:duo_tracker/src/http/adapter/word_hint_api_adapter.dart';
import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/http_status.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';

class LearnedWordApiAdapter extends ApiAdapter {
  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    final response = await DuolingoApi.learnedWord.request.send();
    final httpStatus = HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(response.body);
      final String languageString = jsonMap['language_string'];
      final String learningLanguage = jsonMap['learning_language'];
      final String fromLanguage = jsonMap['from_language'];

      final userId = await CommonSharedPreferencesKey.userId.getString();

      int sortOrder = 0;
      final now = DateTime.now();
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
            formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
              languageCode: learningLanguage,
            ),
            formalFromLanguage: LanguageConverter.toFormalLanguageCode(
              languageCode: fromLanguage,
            ),
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
            sortOrder: sortOrder++,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Update word hint based on word id
        WordHintApiAdapter().execute(
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
