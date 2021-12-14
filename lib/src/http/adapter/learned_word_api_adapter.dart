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
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';

class LearnedWordApiAdapter extends ApiAdapter {
  /// The max length of skill
  static const _maxLengthSkill = 15;

  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    try {
      final response = await Duolingo.instance.overview();

      if (response.status.isOk) {
        final String languageString = response.languageString;
        final String learningLanguage = response.learningLanguage;
        final String fromLanguage = response.fromLanguage;

        final formalLearningLanguage = LanguageConverter.toFormalLanguageCode(
          languageCode: learningLanguage,
        );
        final formalFromLanguage = LanguageConverter.toFormalLanguageCode(
          languageCode: fromLanguage,
        );

        final userId = await CommonSharedPreferencesKey.userId.getString();
        final learnedWords = <LearnedWord>[];

        int sortOrder = 0;
        final now = DateTime.now();
        for (final vocabulary in response.vocabularies) {
          learnedWords.add(
            LearnedWord.from(
              wordId: vocabulary.id,
              userId: userId,
              languageString: languageString,
              learningLanguage: learningLanguage,
              fromLanguage: fromLanguage,
              formalLearningLanguage: formalLearningLanguage,
              formalFromLanguage: formalFromLanguage,
              strengthBars: vocabulary.strengthBars,
              infinitive: vocabulary.infinitive,
              wordString: vocabulary.word,
              normalizedString: vocabulary.normalizedWord,
              pos: vocabulary.pos,
              lastPracticedMs: vocabulary.lastPracticedMs,
              skill: vocabulary.skill,
              shortSkill: _buildShortSkill(skill: vocabulary.skill),
              lastPracticed: vocabulary.lastPracticed,
              strength: vocabulary.proficiency,
              skillUrlTitle: vocabulary.skillUrlTitle,
              gender: vocabulary.gender,
              bookmarked: false,
              completed: false,
              deleted: false,
              sortOrder: sortOrder++,
              createdAt: now,
              updatedAt: now,
            ),
          );
        }

        await _learnedWordService.replaceByIds(
          learnedWords,
        );

        return ApiResponse.from(
          fromApi: FromApi.learnedWord,
          errorType: ErrorType.none,
        );
      } else if (response.status.isClientError) {
        return ApiResponse.from(
          fromApi: FromApi.learnedWord,
          errorType: ErrorType.client,
        );
      } else if (response.status.isServerError) {
        return ApiResponse.from(
          fromApi: FromApi.learnedWord,
          errorType: ErrorType.server,
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.unknown,
      );
    } catch (e) {
      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.unknown,
      );
    }
  }

  String _buildShortSkill({
    required String skill,
  }) {
    if (skill.length <= _maxLengthSkill) {
      return skill;
    }

    return skill.substring(0, _maxLengthSkill - 3) + '...';
  }
}
