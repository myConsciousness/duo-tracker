// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/tips_and_notes_column.dart';
import 'package:duo_tracker/src/repository/model/tips_and_notes_model.dart';
import 'package:duo_tracker/src/repository/tips_and_notes_repository.dart';

class TipsAndNotesService extends TipsAndNotesRepository {
  /// The internal constructor.
  TipsAndNotesService._internal();

  /// Returns the singleton instance of [TipsAndNotesService].
  factory TipsAndNotesService.getInstance() => _singletonInstance;

  /// The singleton instance of this [TipsAndNotesService].
  static final _singletonInstance = TipsAndNotesService._internal();

  @override
  Future<void> delete(TipsAndNotes model) async => await super.database.then(
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
  Future<List<TipsAndNotes>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? TipsAndNotes.fromMap(e)
                        : TipsAndNotes.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<TipsAndNotes> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? TipsAndNotes.fromMap(entity[0])
              : TipsAndNotes.empty(),
        ),
      );

  @override
  Future<TipsAndNotes> insert(TipsAndNotes model) async {
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
  Future<TipsAndNotes> replace(TipsAndNotes model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'TIPS_AND_NOTES';

  @override
  Future<void> update(TipsAndNotes model) async => await super.database.then(
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
  Future<int> findIdBySkillIdAndContent({
    required String skillId,
    required String content,
  }) async =>
      await super
          .database
          .then((database) => database.query(table,
              columns: [
                TipsAndNotesColumn.id,
              ],
              where: 'SKILL_ID = ? AND CONTENT = ?',
              whereArgs: [
                skillId,
                content,
              ]))
          .then((entity) =>
              entity.isEmpty ? -1 : entity[0][TipsAndNotesColumn.id] as int);
}
