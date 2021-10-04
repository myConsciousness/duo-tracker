// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/learned_word_folder_item_repository.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_item_model.dart';

class LearnedWordFolderItemService extends LearnedWordFolderItemRepository {
  /// The internal constructor.
  LearnedWordFolderItemService._internal();

  /// Returns the singleton instance of [LearnedWordFolderItemService].
  factory LearnedWordFolderItemService.getInstance() => _singletonInstance;

  /// The singleton instance of this [LearnedWordFolderItemService].
  static final _singletonInstance = LearnedWordFolderItemService._internal();

  @override
  Future<void> delete(LearnedWordFolderItem model) async =>
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
  Future<List<LearnedWordFolderItem>> findAll() async =>
      await super.database.then(
            (database) => database.query(table).then(
                  (v) => v
                      .map(
                        (e) => e.isNotEmpty
                            ? LearnedWordFolderItem.fromMap(e)
                            : LearnedWordFolderItem.empty(),
                      )
                      .toList(),
                ),
          );

  @override
  Future<LearnedWordFolderItem> findById(int id) async =>
      await super.database.then(
            (database) =>
                database.query(table, where: 'ID = ?', whereArgs: [id]).then(
              (entity) => entity.isNotEmpty
                  ? LearnedWordFolderItem.fromMap(entity[0])
                  : LearnedWordFolderItem.empty(),
            ),
          );

  @override
  Future<List<LearnedWordFolderItem>>
      findByUserIdAndFromLanguageAndLearningLanguage({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
          await super.database.then(
                (database) => database.query(
                  table,
                  where:
                      'USER_ID = ? AND FROM_LANGUAGE = ? AND LEARNING_LANGUAGE = ?',
                  whereArgs: [
                    userId,
                    fromLanguage,
                    learningLanguage,
                  ],
                ).then(
                  (v) => v
                      .map(
                        (e) => e.isNotEmpty
                            ? LearnedWordFolderItem.fromMap(e)
                            : LearnedWordFolderItem.empty(),
                      )
                      .toList(),
                ),
              );

  @override
  Future<LearnedWordFolderItem> insert(LearnedWordFolderItem model) async {
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
  Future<LearnedWordFolderItem> replace(LearnedWordFolderItem model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'LEARNED_WORD_FOLDER_ITEM';

  @override
  Future<void> update(LearnedWordFolderItem model) async =>
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
}
