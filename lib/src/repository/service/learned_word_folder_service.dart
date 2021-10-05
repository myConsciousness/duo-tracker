// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/learned_word_folder_repository.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';

class LearnedWordFolderService extends LearnedWordFolderRepository {
  /// The internal constructor.
  LearnedWordFolderService._internal();

  /// Returns the singleton instance of [LearnedWordFolderService].
  factory LearnedWordFolderService.getInstance() => _singletonInstance;

  /// The singleton instance of this [LearnedWordFolderService].
  static final _singletonInstance = LearnedWordFolderService._internal();

  @override
  Future<void> delete(LearnedWordFolder model) async =>
      await super.database.then(
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
  Future<List<LearnedWordFolder>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? LearnedWordFolder.fromMap(e)
                        : LearnedWordFolder.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<LearnedWordFolder> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? LearnedWordFolder.fromMap(entity[0])
              : LearnedWordFolder.empty(),
        ),
      );

  @override
  Future<LearnedWordFolder> insert(LearnedWordFolder model) async {
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
  Future<LearnedWordFolder> replace(LearnedWordFolder model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'LEARNED_WORD_FOLDER';

  @override
  Future<void> update(LearnedWordFolder model) async =>
      await super.database.then(
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
  Future<List<LearnedWordFolder>>
      findByUserIdAndFromLanguageAndLearningLanguage({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then(
                (database) => database
                    .query(
                      table,
                      where:
                          'USER_ID = ? AND FROM_LANGUAGE = ? AND LEARNING_LANGUAGE = ?',
                      whereArgs: [
                        userId,
                        fromLanguage,
                        learningLanguage,
                      ],
                      orderBy: 'CREATED_AT DESC',
                    )
                    .then(
                      (v) => v
                          .map(
                            (e) => e.isNotEmpty
                                ? LearnedWordFolder.fromMap(e)
                                : LearnedWordFolder.empty(),
                          )
                          .toList(),
                    ),
              );

  @override
  Future<bool>
      checkExistByFolderNameAndUserIdAndFromLanguageAndLearningLanguage({
    required String folderName,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then((database) => database.rawQuery('''
              SELECT
                COUNT(*) ITEM_COUNT
              FROM
                $table
              WHERE
                1 = 1
                AND NAME = ?
                AND USER_ID = ?
                AND FROM_LANGUAGE = ?
                AND LEARNING_LANGUAGE = ?
              ''', [
                folderName,
                userId,
                fromLanguage,
                learningLanguage
              ]).then((entity) =>
                  entity.isEmpty ? 0 : entity[0]['ITEM_COUNT'] as int)) >
          0;
}
