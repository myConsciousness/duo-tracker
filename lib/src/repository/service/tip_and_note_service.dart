// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/utils/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/tip_and_note_column.dart';
import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';
import 'package:duo_tracker/src/repository/tip_and_note_repository.dart';

class TipAndNoteService extends TipAndNoteRepository {
  /// The internal constructor.
  TipAndNoteService._internal();

  /// Returns the singleton instance of [TipAndNoteService].
  factory TipAndNoteService.getInstance() => _singletonInstance;

  /// The singleton instance of this [TipAndNoteService].
  static final _singletonInstance = TipAndNoteService._internal();

  @override
  Future<bool> checkExistBySkillIdAndContent({
    required String skillId,
    required String content,
  }) async =>
      await super.database.then((database) => database.rawQuery('''
              SELECT
                COUNT(*) ITEM_COUNT
              FROM
                $table
              WHERE
                1 = 1
                AND SKILL_ID = ?
                AND CONTENT = ?
              ''', [
            skillId,
            content,
          ]).then((entity) =>
              entity.isEmpty ? 0 : entity[0]['ITEM_COUNT'] as int)) >
      0;

  @override
  Future<void> delete(TipAndNote model) async => await super.database.then(
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
  Future<List<TipAndNote>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? TipAndNote.fromMap(e)
                        : TipAndNote.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<TipAndNote> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? TipAndNote.fromMap(entity[0])
              : TipAndNote.empty(),
        ),
      );

  @override
  Future<TipAndNote> findBySkillIdAndContentAndUserId({
    required String skillId,
    required String content,
    required String userId,
  }) async =>
      await super.database.then(
            (database) => database.query(table,
                where: 'SKILL_ID = ? AND CONTENT = ? AND USER_ID = ?',
                whereArgs: [
                  skillId,
                  content,
                  userId,
                ]).then(
              (entity) => entity.isNotEmpty
                  ? TipAndNote.fromMap(entity[0])
                  : TipAndNote.empty(),
            ),
          );

  @override
  Future<List<TipAndNote>>
      findByUserIdAndFromLanguageAndLearningLanguageAndBookmarkedTrueAndDeletedFalse({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then(
                (database) => database
                    .query(
                      table,
                      where:
                          'USER_ID = ? AND FROM_LANGUAGE = ? AND LEARNING_LANGUAGE = ? AND BOOKMARKED = ? AND DELETED = ?',
                      whereArgs: [
                        userId,
                        fromLanguage,
                        learningLanguage,
                        BooleanText.true_,
                        BooleanText.false_,
                      ],
                      orderBy: 'SORT_ORDER',
                    )
                    .then(
                      (v) => v
                          .map(
                            (e) => e.isNotEmpty
                                ? TipAndNote.fromMap(e)
                                : TipAndNote.empty(),
                          )
                          .toList(),
                    ),
              );

  @override
  Future<List<TipAndNote>>
      findByUserIdAndFromLanguageAndLearningLanguageAndDeletedFalse({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then(
                (database) => database
                    .query(
                      table,
                      where:
                          'USER_ID = ? AND FROM_LANGUAGE = ? AND LEARNING_LANGUAGE = ? AND DELETED = ?',
                      whereArgs: [
                        userId,
                        fromLanguage,
                        learningLanguage,
                        BooleanText.false_,
                      ],
                      orderBy: 'SORT_ORDER',
                    )
                    .then(
                      (v) => v
                          .map(
                            (e) => e.isNotEmpty
                                ? TipAndNote.fromMap(e)
                                : TipAndNote.empty(),
                          )
                          .toList(),
                    ),
              );

  @override
  Future<List<TipAndNote>>
      findByUserIdAndFromLanguageAndLearningLanguageAndDeletedTrue({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then(
                (database) => database
                    .query(
                      table,
                      where:
                          'USER_ID = ? AND FROM_LANGUAGE = ? AND LEARNING_LANGUAGE = ? AND DELETED = ?',
                      whereArgs: [
                        userId,
                        fromLanguage,
                        learningLanguage,
                        BooleanText.true_,
                      ],
                      orderBy: 'SORT_ORDER',
                    )
                    .then(
                      (v) => v
                          .map(
                            (e) => e.isNotEmpty
                                ? TipAndNote.fromMap(e)
                                : TipAndNote.empty(),
                          )
                          .toList(),
                    ),
              );

  @override
  Future<int> findIdBySkillIdAndContent({
    required String skillId,
    required String content,
  }) async =>
      await super
          .database
          .then((database) => database.query(table,
              columns: [
                TipAndNoteColumn.id,
              ],
              where: 'SKILL_ID = ? AND CONTENT = ?',
              whereArgs: [
                skillId,
                content,
              ]))
          .then((entity) =>
              entity.isEmpty ? -1 : entity[0][TipAndNoteColumn.id] as int);

  @override
  Future<TipAndNote> insert(TipAndNote model) async {
    model.sortOrder =
        await _findMaxSortOrderByUserIdAndFromLanguageAndLearningLanguage(
      userId: model.userId,
      fromLanguage: model.fromLanguage,
      learningLanguage: model.learningLanguage,
    );

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
  Future<TipAndNote> replace(TipAndNote model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  Future<TipAndNote> replaceById({
    required TipAndNote tipAndNote,
  }) async {
    TipAndNote storedTipAndNote = await findBySkillIdAndContentAndUserId(
      skillId: tipAndNote.skillId,
      content: tipAndNote.content,
      userId: tipAndNote.userId,
    );

    if (storedTipAndNote.isEmpty()) {
      storedTipAndNote = await insert(tipAndNote);
    } else {
      tipAndNote.id = storedTipAndNote.id;
      tipAndNote.bookmarked = storedTipAndNote.bookmarked;
      tipAndNote.deleted = storedTipAndNote.deleted;
      tipAndNote.sortOrder = storedTipAndNote.sortOrder;
      tipAndNote.createdAt = storedTipAndNote.createdAt;

      await update(tipAndNote);
    }

    return storedTipAndNote;
  }

  @override
  Future<void> replaceSortOrdersByIds({
    required List<TipAndNote> tipsAndNotes,
  }) async {
    tipsAndNotes.asMap().forEach((index, tipAndNote) async {
      final storedLearnedWord = await findById(
        tipAndNote.id,
      );

      storedLearnedWord.sortOrder = index;

      await update(storedLearnedWord);
    });
  }

  @override
  String get table => 'TIP_AND_NOTE';

  @override
  Future<void> update(TipAndNote model) async => await super.database.then(
        (database) => database.update(
          table,
          model.toMap(),
          where: 'ID = ?',
          whereArgs: [
            model.id,
          ],
        ),
      );

  Future<int> _findMaxSortOrderByUserIdAndFromLanguageAndLearningLanguage({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
      await super
          .database
          .then(
            (database) => database.rawQuery(
              '''
                  SELECT
                    CASE WHEN
                      MAX_SORT_ORDER IS NULL THEN 0
                      ELSE MAX_SORT_ORDER + 1
                    END MAX_SORT_ORDER
                  FROM
                    (
                      SELECT
                        MAX(SORT_ORDER) MAX_SORT_ORDER
                      FROM
                        $table
                      WHERE
                        1 = 1
                        AND USER_ID = ?
                        AND FROM_LANGUAGE = ?
                        AND LEARNING_LANGUAGE = ?
                    )
                  ''',
              [
                userId,
                fromLanguage,
                learningLanguage,
              ],
            ),
          )
          .then((entity) =>
              entity.isEmpty ? 0 : entity[0]['MAX_SORT_ORDER'] as int);
}
