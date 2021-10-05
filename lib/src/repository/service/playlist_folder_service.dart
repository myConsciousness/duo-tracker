// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/playlist_folder_model.dart';
import 'package:duo_tracker/src/repository/playlist_folder_repository.dart';

class PlaylistFolderService extends PlaylistFolderRepository {
  /// The internal constructor.
  PlaylistFolderService._internal();

  /// Returns the singleton instance of [PlaylistFolderService].
  factory PlaylistFolderService.getInstance() => _singletonInstance;

  /// The singleton instance of this [PlaylistFolderService].
  static final _singletonInstance = PlaylistFolderService._internal();

  @override
  Future<void> delete(PlaylistFolder model) async => await super.database.then(
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
  Future<List<PlaylistFolder>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? PlaylistFolder.fromMap(e)
                        : PlaylistFolder.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<PlaylistFolder> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? PlaylistFolder.fromMap(entity[0])
              : PlaylistFolder.empty(),
        ),
      );

  @override
  Future<PlaylistFolder> insert(PlaylistFolder model) async {
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
  Future<PlaylistFolder> replace(PlaylistFolder model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'PLAYLIST_FOLDER';

  @override
  Future<void> update(PlaylistFolder model) async => await super.database.then(
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
