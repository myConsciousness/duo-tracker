// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/skill_model.dart';
import 'package:duo_tracker/src/repository/service/tip_and_note_service.dart';
import 'package:duo_tracker/src/repository/skill_repository.dart';

class SkillService extends SkillRepository {
  /// The internal constructor.
  SkillService._internal();

  /// Returns the singleton instance of [SkillService].
  factory SkillService.getInstance() => _singletonInstance;

  /// The singleton instance of this [SkillService].
  static final _singletonInstance = SkillService._internal();

  /// The tip and note service
  final _tipsAndNotesService = TipAndNoteService.getInstance();

  @override
  Future<void> delete(Skill model) async => await super.database.then(
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
  Future<List<Skill>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty ? Skill.fromMap(e) : Skill.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<Skill> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) =>
              entity.isNotEmpty ? Skill.fromMap(entity[0]) : Skill.empty(),
        ),
      );

  @override
  Future<Skill> findByName({required String name}) async {
    final skill = await super.database.then(
          (database) =>
              database.query(table, where: 'NAME = ?', whereArgs: [name]).then(
            (entity) =>
                entity.isNotEmpty ? Skill.fromMap(entity[0]) : Skill.empty(),
          ),
        );

    if (skill.tipAndNoteId > -1) {
      skill.tipAndNote = await _tipsAndNotesService.findById(
        skill.tipAndNoteId,
      );
    }

    return skill;
  }

  @override
  Future<Skill> insert(Skill model) async {
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
  Future<Skill> replace(Skill model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'SKILL';

  @override
  Future<void> update(Skill model) async => await super.database.then(
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
  Future<void> insertAll({
    required List<Skill> skills,
  }) async {
    await database.then((database) async {
      final batch = database.batch();

      for (final skill in skills) {
        batch.insert(table, skill.toMap());
      }

      await batch.commit(noResult: true);
    });
  }
}
