// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/repository/folder_repository.dart';
import 'package:duo_tracker/src/repository/model/folder_model.dart';

class FolderService extends FolderRepository {
  /// The internal constructor.
  FolderService._internal();

  /// Returns the singleton instance of [FolderService].
  factory FolderService.getInstance() => _singletonInstance;

  /// The singleton instance of this [FolderService].
  static final _singletonInstance = FolderService._internal();

  @override
  Future<void> delete(Folder model) async => await super.database.then(
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
  Future<List<Folder>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty ? Folder.fromMap(e) : Folder.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<Folder> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) =>
              entity.isNotEmpty ? Folder.fromMap(entity[0]) : Folder.empty(),
        ),
      );

  @override
  Future<Folder> insert(Folder model) async {
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
  Future<Folder> replace(Folder model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'FOLDER';

  @override
  Future<void> update(Folder model) async => await super.database.then(
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
  Future<List<Folder>>
      findByFolderTypeAndUserIdAndFromLanguageAndLearningLanguage({
    required FolderType folderType,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then(
                (database) => database
                    .query(
                      table,
                      where:
                          'FOLDER_TYPE = ? AND USER_ID = ? AND FROM_LANGUAGE = ? AND LEARNING_LANGUAGE = ?',
                      whereArgs: [
                        folderType.code,
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
                                ? Folder.fromMap(e)
                                : Folder.empty(),
                          )
                          .toList(),
                    ),
              );

  @override
  Future<bool>
      checkExistByFolderTypeAndNameAndUserIdAndFromLanguageAndLearningLanguage({
    required FolderType folderType,
    required String name,
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
                AND FOLDER_TYPE = ?
                AND NAME = ?
                AND USER_ID = ?
                AND FROM_LANGUAGE = ?
                AND LEARNING_LANGUAGE = ?
              ''', [
                folderType.code,
                name,
                userId,
                fromLanguage,
                learningLanguage
              ]).then((entity) =>
                  entity.isEmpty ? 0 : entity[0]['ITEM_COUNT'] as int)) >
          0;
}
