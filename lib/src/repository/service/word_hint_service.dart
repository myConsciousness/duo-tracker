// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/word_hint_repository.dart';

class WordHintService extends WordHintRepository {
  /// The internal constructor.
  WordHintService._internal();

  /// Returns the singleton instance of [WordHintService].
  factory WordHintService.getInstance() => _singletonInstance;

  /// The singleton instance of this [WordHintService].
  static final _singletonInstance = WordHintService._internal();

  @override
  Future<void> delete(WordHint model) async => await super.database.then(
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
  Future<List<WordHint>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) =>
                        e.isNotEmpty ? WordHint.fromMap(e) : WordHint.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<WordHint> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? WordHint.fromMap(entity[0])
              : WordHint.empty(),
        ),
      );

  @override
  Future<List<WordHint>> findByWordIdAndUserId(
    String wordId,
    String userId,
  ) async =>
      await super.database.then(
            (database) => database
                .query(
                  table,
                  where: 'WORD_ID = ? AND USER_ID = ?',
                  whereArgs: [
                    wordId,
                    userId,
                  ],
                  orderBy: 'CREATED_AT DESC',
                )
                .then(
                  (entities) => entities
                      .map((entity) => entity.isNotEmpty
                          ? WordHint.fromMap(entity)
                          : WordHint.empty())
                      .toList(),
                ),
          );

  @override
  Future<WordHint> insert(WordHint model) async {
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
  Future<WordHint> replace(WordHint model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'WORD_HINT';

  @override
  Future<void> update(WordHint model) async => await super.database.then(
        (database) => database.update(
          table,
          model.toMap(),
          where: 'ID = ?',
          whereArgs: [
            model.id,
          ],
        ),
      );
}
