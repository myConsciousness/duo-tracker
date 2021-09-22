// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/dialog/select_filter_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_sort_method_dialog.dart';
import 'package:duo_tracker/src/repository/learned_word_repository.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/skill_serviced.dart';
import 'package:duo_tracker/src/repository/service/voice_configuration_service.dart';
import 'package:duo_tracker/src/repository/service/word_hint_service.dart';

class LearnedWordService extends LearnedWordRepository {
  /// The internal constructor.
  LearnedWordService._internal();

  /// Returns the singleton instance of [LearnedWordService].
  factory LearnedWordService.getInstance() => _singletonInstance;

  /// The singleton instance of this [LearnedWordService].
  static final _singletonInstance = LearnedWordService._internal();

  /// The skill service
  final _skillService = SkillService.getInstance();

  /// The voice configuration service
  final _voiceConfigurationService = VoiceConfigurationService.getInstance();

  /// The word hint service
  final _wordHintService = WordHintService.getInstance();

  @override
  Future<void> delete(LearnedWord model) async => await super.database.then(
        (database) => database.delete(
          table,
          where: 'ID = ?',
          whereArgs: [model.id],
        ),
      );

  @override
  Future<void> deleteAll() async => await super.database.then(
        (database) => database.delete(
          table,
        ),
      );

  @override
  Future<void> deleteByWordIdAndUserId(
    String wordId,
    String userId,
  ) async =>
      await super.database.then(
            (database) => database.delete(
              table,
              where: 'WORD_ID = ? AND USER_ID = ?',
              whereArgs: [
                wordId,
                userId,
              ],
            ),
          );

  @override
  Future<List<LearnedWord>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? LearnedWord.fromMap(e)
                        : LearnedWord.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<LearnedWord> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? LearnedWord.fromMap(entity[0])
              : LearnedWord.empty(),
        ),
      );

  @override
  Future<List<LearnedWord>> findByUserIdAndLearningLanguageAndFromLanguage(
    String userId,
    String learningLanguage,
    String fromLanguage,
  ) async {
    final sortItemCode = await CommonSharedPreferencesKey.sortItem.getInt();
    final sortPatternCode =
        await CommonSharedPreferencesKey.sortPattern.getInt();

    final sortColumnName = SortItemExt.toEnum(code: sortItemCode).columnName;
    final sortPattern =
        SortPatternExt.toEnum(code: sortPatternCode).patternName;

    final learedWords = await super.database.then(
          (database) => database
              .query(
                table,
                where:
                    'USER_ID = ? AND LEARNING_LANGUAGE = ? AND FROM_LANGUAGE = ?',
                whereArgs: [
                  userId,
                  learningLanguage,
                  fromLanguage,
                ],
                orderBy: '$sortColumnName $sortPattern',
              )
              .then(
                (entities) => entities
                    .map((entity) => entity.isNotEmpty
                        ? LearnedWord.fromMap(entity)
                        : LearnedWord.empty())
                    .toList(),
              ),
        );

    final voiceConfiguration = await _voiceConfigurationService.findByLanguage(
        language: learningLanguage);
    final String baseTtsVoiceUrl =
        '${voiceConfiguration.ttsBaseUrlHttps}${voiceConfiguration.path}/${voiceConfiguration.voiceType}/token';

    for (final LearnedWord learnedWord in learedWords) {
      if (learnedWord.wordString.contains(' ')) {
        final wordStrings = learnedWord.wordString.split(' ');
        for (final String wordString in wordStrings) {
          learnedWord.ttsVoiceUrls.add('$baseTtsVoiceUrl/$wordString');
        }
      } else {
        learnedWord.ttsVoiceUrls
            .add('$baseTtsVoiceUrl/${learnedWord.wordString}');
      }

      learnedWord.wordHints = await _wordHintService
          .findByWordIdAndUserIdAndSortBySortOrder(learnedWord.wordId, userId);

      final skill = await _skillService.findByName(name: learnedWord.skill);
      learnedWord.tipsAndNotes = skill.tipsAndNotes;
    }

    return learedWords;
  }

  @override
  Future<LearnedWord> findByWordIdAndUserId(
          String wordId, String userId) async =>
      await super.database.then(
            (database) => database.query(
              table,
              where: 'WORD_ID = ? AND USER_ID = ?',
              whereArgs: [
                wordId,
                userId,
              ],
            ).then(
              (entity) => entity.isNotEmpty
                  ? LearnedWord.fromMap(entity[0])
                  : LearnedWord.empty(),
            ),
          );

  @override
  Future<LearnedWord> insert(LearnedWord model) async {
    await super.database.then(
          (database) => database
              .insert(
                table,
                model.toMap(),
              )
              .then(
                (int id) async => model.id = id,
              ),
        );

    return model;
  }

  @override
  Future<LearnedWord> replace(LearnedWord model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  Future<LearnedWord> replaceById(LearnedWord learnedWord) async {
    LearnedWord storedLearnedWord = await findByWordIdAndUserId(
      learnedWord.wordId,
      learnedWord.userId,
    );

    if (storedLearnedWord.isEmpty()) {
      storedLearnedWord = await insert(learnedWord);
    } else {
      learnedWord.id = storedLearnedWord.id;
      learnedWord.bookmarked = storedLearnedWord.bookmarked;
      learnedWord.completed = storedLearnedWord.completed;
      learnedWord.deleted = storedLearnedWord.deleted;
      learnedWord.sortOrder = storedLearnedWord.sortOrder;
      learnedWord.createdAt = storedLearnedWord.createdAt;

      await update(learnedWord);
    }

    return storedLearnedWord;
  }

  @override
  Future<void> replaceSortOrdersByIds(List<LearnedWord> learnedWords) async {
    learnedWords.asMap().forEach((index, learnedWord) async {
      LearnedWord storedLearnedWord = await findByWordIdAndUserId(
        learnedWord.wordId,
        learnedWord.userId,
      );

      storedLearnedWord.sortOrder = index;
      storedLearnedWord.updatedAt = DateTime.now();

      await update(storedLearnedWord);
    });
  }

  @override
  String get table => 'LEARNED_WORD';

  @override
  Future<void> update(LearnedWord model) async => await super.database.then(
        (database) => database.update(
          table,
          model.toMap(),
          where: 'ID = ?',
          whereArgs: [
            model.id,
          ],
        ),
      );

  @override
  Future<List<String>>
      findDistinctFilterItemByUserIdAndLearningLanguageAndFromLanguage({
    required FilterItem filterItem,
    required String userId,
    required String learningLanguage,
    required String fromLanguage,
  }) async =>
          await super.database.then((database) => database
              .query(
                table,
                distinct: true,
                columns: [],
                where:
                    'USER_ID = ? AND LEARNING_LANGUAGE = ? AND FROM_LANGUAGE = ?',
                whereArgs: [
                  userId,
                  learningLanguage,
                  fromLanguage,
                ],
                orderBy: '',
              )
              .then(
                (entities) => entities
                    .map(
                      (entity) => entity['FROM_LANGUAGE'] as String,
                    )
                    .toList(),
              ));
}
