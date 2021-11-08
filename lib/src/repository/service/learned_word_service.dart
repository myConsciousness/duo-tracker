// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/const/filter_pattern.dart';
import 'package:duo_tracker/src/component/const/sort_item.dart';
import 'package:duo_tracker/src/component/const/sort_pattern.dart';
import 'package:duo_tracker/src/repository/learned_word_repository.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/voice_configuration_service.dart';
import 'package:duo_tracker/src/repository/utils/shared_preferences_utils.dart';

class LearnedWordService extends LearnedWordRepository {
  /// The internal constructor.
  LearnedWordService._internal();

  /// Returns the singleton instance of [LearnedWordService].
  factory LearnedWordService.getInstance() => _singletonInstance;

  /// The singleton instance of this [LearnedWordService].
  static final _singletonInstance = LearnedWordService._internal();

  /// The voice configuration service
  final _voiceConfigurationService = VoiceConfigurationService.getInstance();

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
    final sortItemCode =
        await SharedPreferencesUtils.getCurrentIntValueOrDefault(
      currentKey: CommonSharedPreferencesKey.sortItem,
      defaultKey: CommonSharedPreferencesKey.overviewDefaultSortItem,
    );
    final sortPatternCode =
        await SharedPreferencesUtils.getCurrentIntValueOrDefault(
      currentKey: CommonSharedPreferencesKey.sortPattern,
      defaultKey: CommonSharedPreferencesKey.overviewDefaultSortPattern,
    );

    final sortColumnName = SortItemExt.toEnum(code: sortItemCode).columnName;
    final sortPattern =
        SortPatternExt.toEnum(code: sortPatternCode).patternName;

    final learnedWords = await super.database.then(
          (database) => database.rawQuery(
            '''
            SELECT
              LW.ID,
              LW.WORD_ID,
              LW.USER_ID,
              LW.LANGUAGE_STRING,
              LW.LEARNING_LANGUAGE,
              LW.FROM_LANGUAGE,
              LW.FORMAL_LEARNING_LANGUAGE,
              LW.FORMAL_FROM_LANGUAGE,
              LW.STRENGTH_BARS,
              LW.INFINITIVE,
              LW.WORD_STRING,
              LW.NORMALIZED_STRING,
              LW.POS,
              LW.LAST_PRACTICED_MS,
              LW.SKILL,
              LW.SHORT_SKILL,
              LW.LAST_PRACTICED,
              LW.STRENGTH,
              LW.SKILL_URL_TITLE,
              LW.GENDER,
              LW.BOOKMARKED,
              LW.COMPLETED,
              LW.DELETED,
              LW.SORT_ORDER,
              LW.CREATED_AT,
              LW.UPDATED_AT,
              TAN.ID TAN_ID,
              TAN.SKILL_ID TAN_SKILL_ID,
              TAN.SKILL_NAME TAN_SKILL_NAME,
              TAN.CONTENT TAN_CONTENT,
              TAN.CONTENT_SUMMARY TAN_CONTENT_SUMMARY,
              TAN.USER_ID TAN_USER_ID,
              TAN.FROM_LANGUAGE TAN_FROM_LANGUAGE,
              TAN.LEARNING_LANGUAGE TAN_LEARNING_LANGUAGE,
              TAN.FORMAL_FROM_LANGUAGE TAN_FORMAL_FROM_LANGUAGE,
              TAN.FORMAL_LEARNING_LANGUAGE TAN_FORMAL_LEARNING_LANGUAGE,
              TAN.SORT_ORDER TAN_SORT_ORDER,
              TAN.BOOKMARKED TAN_BOOKMARKED,
              TAN.DELETED TAN_DELETED,
              TAN.CREATED_AT TAN_CREATED_AT,
              TAN.UPDATED_AT TAN_UPDATED_AT
            FROM
              LEARNED_WORD LW
              LEFT OUTER JOIN
                (
                  SELECT
                    TANI.ID,
                    TANI.SKILL_ID,
                    TANI.SKILL_NAME,
                    TANI.CONTENT,
                    TANI.CONTENT_SUMMARY,
                    TANI.USER_ID,
                    TANI.FROM_LANGUAGE,
                    TANI.LEARNING_LANGUAGE,
                    TANI.FORMAL_FROM_LANGUAGE,
                    TANI.FORMAL_LEARNING_LANGUAGE,
                    TANI.SORT_ORDER,
                    TANI.BOOKMARKED,
                    TANI.DELETED,
                    TANI.CREATED_AT,
                    TANI.UPDATED_AT
                  FROM
                    SKILL S
                    INNER JOIN TIP_AND_NOTE TANI ON S.TIP_AND_NOTE_ID = TANI.ID
                ) TAN ON LW.SKILL = TAN.SKILL_NAME AND LW.USER_ID = TAN.USER_ID
            WHERE
              1 = 1
              AND LW.USER_ID = ?
              AND LW.LEARNING_LANGUAGE = ?
              AND LW.FROM_LANGUAGE = ?
            ORDER BY
              LW.$sortColumnName $sortPattern
          ''',
            [
              userId,
              learningLanguage,
              fromLanguage,
            ],
          ).then(
            (entities) => entities
                .map((entity) => entity.isNotEmpty
                    ? LearnedWord.fromMap(entity)
                    : LearnedWord.empty())
                .toList(),
          ),
        );

    await _correctModelObject(
      learnedWords: learnedWords,
      learningLanguage: learningLanguage,
    );

    return learnedWords;
  }

  @override
  Future<List<LearnedWord>>
      findByUserIdAndLearningLanguageAndFromLanguageOrderByLastPracticedMsDesc({
    required String userId,
    required String learningLanguage,
    required String fromLanguage,
  }) async =>
          database.then(
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
                  orderBy: 'LAST_PRACTICED_MS DESC',
                )
                .then(
                  (entities) => entities
                      .map((entity) => entity.isNotEmpty
                          ? LearnedWord.fromMap(entity)
                          : LearnedWord.empty())
                      .toList(),
                ),
          );

  @override
  Future<LearnedWord> findByWordIdAndUserId(
      String wordId, String userId) async {
    final learnedWords = [
      await super.database.then(
            (database) => database.rawQuery(
              '''
              SELECT
                LW.ID,
                LW.WORD_ID,
                LW.USER_ID,
                LW.LANGUAGE_STRING,
                LW.LEARNING_LANGUAGE,
                LW.FROM_LANGUAGE,
                LW.FORMAL_LEARNING_LANGUAGE,
                LW.FORMAL_FROM_LANGUAGE,
                LW.STRENGTH_BARS,
                LW.INFINITIVE,
                LW.WORD_STRING,
                LW.NORMALIZED_STRING,
                LW.POS,
                LW.LAST_PRACTICED_MS,
                LW.SKILL,
                LW.SHORT_SKILL,
                LW.LAST_PRACTICED,
                LW.STRENGTH,
                LW.SKILL_URL_TITLE,
                LW.GENDER,
                LW.BOOKMARKED,
                LW.COMPLETED,
                LW.DELETED,
                LW.SORT_ORDER,
                LW.CREATED_AT,
                LW.UPDATED_AT,
                TAN.ID TAN_ID,
                TAN.SKILL_ID TAN_SKILL_ID,
                TAN.SKILL_NAME TAN_SKILL_NAME,
                TAN.CONTENT TAN_CONTENT,
                TAN.CONTENT_SUMMARY TAN_CONTENT_SUMMARY,
                TAN.USER_ID TAN_USER_ID,
                TAN.FROM_LANGUAGE TAN_FROM_LANGUAGE,
                TAN.LEARNING_LANGUAGE TAN_LEARNING_LANGUAGE,
                TAN.FORMAL_FROM_LANGUAGE TAN_FORMAL_FROM_LANGUAGE,
                TAN.FORMAL_LEARNING_LANGUAGE TAN_FORMAL_LEARNING_LANGUAGE,
                TAN.SORT_ORDER TAN_SORT_ORDER,
                TAN.BOOKMARKED TAN_BOOKMARKED,
                TAN.DELETED TAN_DELETED,
                TAN.CREATED_AT TAN_CREATED_AT,
                TAN.UPDATED_AT TAN_UPDATED_AT
              FROM
                LEARNED_WORD LW
                LEFT OUTER JOIN
                  (
                    SELECT
                      TANI.ID,
                      TANI.SKILL_ID,
                      TANI.SKILL_NAME,
                      TANI.CONTENT,
                      TANI.CONTENT_SUMMARY,
                      TANI.USER_ID,
                      TANI.FROM_LANGUAGE,
                      TANI.LEARNING_LANGUAGE,
                      TANI.FORMAL_FROM_LANGUAGE,
                      TANI.FORMAL_LEARNING_LANGUAGE,
                      TANI.SORT_ORDER,
                      TANI.BOOKMARKED,
                      TANI.DELETED,
                      TANI.CREATED_AT,
                      TANI.UPDATED_AT
                    FROM
                     SKILL S
                     INNER JOIN TIP_AND_NOTE TANI ON S.TIP_AND_NOTE_ID = TANI.ID
                  ) TAN ON LW.SKILL = TAN.SKILL_NAME AND LW.USER_ID = TAN.USER_ID
              WHERE
                1 = 1
                AND LW.WORD_ID = ?
                AND LW.USER_ID = ?
            ''',
              [
                wordId,
                userId,
              ],
            ).then(
              (entity) => entity.isNotEmpty
                  ? LearnedWord.fromMap(entity[0])
                  : LearnedWord.empty(),
            ),
          )
    ];

    await _correctModelObject(
      learnedWords: learnedWords,
      learningLanguage: learnedWords[0].learningLanguage,
    );

    return learnedWords[0];
  }

  @override
  Future<List<String>>
      findDistinctFilterPatternByUserIdAndLearningLanguageAndFromLanguage({
    required FilterPattern filterPattern,
    required String userId,
    required String learningLanguage,
    required String fromLanguage,
  }) async =>
          await super.database.then((database) => database
              .query(
                table,
                distinct: true,
                columns: [filterPattern.columnName],
                where:
                    'USER_ID = ? AND LEARNING_LANGUAGE = ? AND FROM_LANGUAGE = ?',
                whereArgs: [
                  userId,
                  learningLanguage,
                  fromLanguage,
                ],
                orderBy: filterPattern.columnName,
              )
              .then(
                (entities) => entities.map(
                  (entity) {
                    final dynamic value = entity[filterPattern.columnName];

                    if (filterPattern == FilterPattern.strength) {
                      return value.toString();
                    }

                    return entity[filterPattern.columnName] as String;
                  },
                ).toList(),
              ));

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
  Future<void> replaceByIds(List<LearnedWord> learnedWords) async {
    await database.then((database) async {
      final batch = database.batch();

      for (final learnedWord in learnedWords) {
        final LearnedWord storedLearnedWord = await findByWordIdAndUserId(
          learnedWord.wordId,
          learnedWord.userId,
        );

        if (storedLearnedWord.isEmpty()) {
          batch.insert(table, learnedWord.toMap());
        } else {
          learnedWord.id = storedLearnedWord.id;
          learnedWord.bookmarked = storedLearnedWord.bookmarked;
          learnedWord.completed = storedLearnedWord.completed;
          learnedWord.deleted = storedLearnedWord.deleted;
          learnedWord.sortOrder = storedLearnedWord.sortOrder;
          learnedWord.createdAt = storedLearnedWord.createdAt;

          batch.update(
            table,
            learnedWord.toMap(),
            where: 'ID = ?',
            whereArgs: [
              learnedWord.id,
            ],
          );
        }
      }

      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> replaceSortOrdersByIds(List<LearnedWord> learnedWords) async {
    await database.then((database) async {
      final batch = database.batch();

      int index = 0;
      for (final learnedWord in learnedWords) {
        final storedLearnedWord = await findByWordIdAndUserId(
          learnedWord.wordId,
          learnedWord.userId,
        );

        storedLearnedWord.sortOrder = index;

        batch.update(
          table,
          storedLearnedWord.toMap(),
          where: 'ID = ?',
          whereArgs: [
            storedLearnedWord.id,
          ],
        );

        index++;
      }

      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> resetSortOrderByUserIdAndLearningLanguageAndFromLanguage({
    required String userId,
    required String learningLanguage,
    required String fromLanguage,
  }) async {
    // The words returned by the Duolingo API are in descending order of the last learning date.
    final learnedWords =
        await findByUserIdAndLearningLanguageAndFromLanguageOrderByLastPracticedMsDesc(
      userId: userId,
      learningLanguage: learningLanguage,
      fromLanguage: fromLanguage,
    );

    int index = 0;
    final now = DateTime.now();
    for (final learnedWord in learnedWords) {
      learnedWord.sortOrder = index;
      learnedWord.updatedAt = now;

      update(learnedWord);
      index++;
    }
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

  Future<void> _correctModelObject({
    required List<LearnedWord> learnedWords,
    required String learningLanguage,
  }) async {
    final voiceConfiguration = await _voiceConfigurationService.findByLanguage(
      language: learningLanguage,
    );

    final baseTtsVoiceUrl =
        '${voiceConfiguration.ttsBaseUrlHttps}${voiceConfiguration.path}/${voiceConfiguration.voiceType}/token';

    for (final learnedWord in learnedWords) {
      if (learnedWord.wordString.contains(' ')) {
        final wordStrings = learnedWord.wordString.split(' ');
        for (final wordString in wordStrings) {
          learnedWord.ttsVoiceUrls.add('$baseTtsVoiceUrl/$wordString');
        }
      } else {
        learnedWord.ttsVoiceUrls
            .add('$baseTtsVoiceUrl/${learnedWord.wordString}');
      }
    }
  }
}
