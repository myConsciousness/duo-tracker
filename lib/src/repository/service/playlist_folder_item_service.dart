// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/playlist_folder_item_model.dart';
import 'package:duo_tracker/src/repository/playlist_folder_item_repository.dart';

class PlaylistFolderItemService extends PlaylistFolderItemRepository {
  /// The internal constructor.
  PlaylistFolderItemService._internal();

  /// Returns the singleton instance of [PlaylistFolderItemService].
  factory PlaylistFolderItemService.getInstance() => _singletonInstance;

  /// The singleton instance of this [PlaylistFolderItemService].
  static final _singletonInstance = PlaylistFolderItemService._internal();

  @override
  Future<void> delete(PlaylistFolderItem model) async =>
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
  Future<List<PlaylistFolderItem>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? PlaylistFolderItem.fromMap(e)
                        : PlaylistFolderItem.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<PlaylistFolderItem> findById(int id) async =>
      await super.database.then(
            (database) =>
                database.query(table, where: 'ID = ?', whereArgs: [id]).then(
              (entity) => entity.isNotEmpty
                  ? PlaylistFolderItem.fromMap(entity[0])
                  : PlaylistFolderItem.empty(),
            ),
          );

  @override
  Future<PlaylistFolderItem> insert(PlaylistFolderItem model) async {
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
  Future<PlaylistFolderItem> replace(PlaylistFolderItem model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'PLAYLIST_FOLDER_ITEM';

  @override
  Future<void> update(PlaylistFolderItem model) async =>
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
