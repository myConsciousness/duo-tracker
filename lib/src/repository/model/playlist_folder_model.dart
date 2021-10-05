// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/playlist_folder_column_name.dart';

class PlaylistFolder {
  int id = -1;
  int parentFolderId;
  String name;
  String alias;
  String remarks;
  String userId;
  String fromLanguage;
  String learningLanguage;
  int sortOrder;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [PlaylistFolder].
  PlaylistFolder.empty()
      : _empty = true,
        parentFolderId = -1,
        name = '',
        alias = '',
        remarks = '',
        userId = '',
        fromLanguage = '',
        learningLanguage = '',
        sortOrder = -1,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [PlaylistFolder] based on the parameters.
  PlaylistFolder.from({
    this.id = -1,
    required this.parentFolderId,
    required this.name,
    required this.alias,
    required this.remarks,
    required this.userId,
    required this.fromLanguage,
    required this.learningLanguage,
    required this.sortOrder,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [PlaylistFolder] based on the [map] passed as an argument.
  factory PlaylistFolder.fromMap(Map<String, dynamic> map) =>
      PlaylistFolder.from(
        id: map[PlaylistFolderColumnName.id],
        parentFolderId: map[PlaylistFolderColumnName.parentFolderId],
        name: map[PlaylistFolderColumnName.name],
        alias: map[PlaylistFolderColumnName.alias],
        remarks: map[PlaylistFolderColumnName.remarks],
        userId: map[PlaylistFolderColumnName.userId],
        fromLanguage: map[PlaylistFolderColumnName.fromLanguage],
        learningLanguage: map[PlaylistFolderColumnName.learningLanguage],
        sortOrder: map[PlaylistFolderColumnName.sortOrder],
        deleted: map[PlaylistFolderColumnName.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[PlaylistFolderColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[PlaylistFolderColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [PlaylistFolder] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[PlaylistFolderColumnName.parentFolderId] = parentFolderId;
    map[PlaylistFolderColumnName.name] = name;
    map[PlaylistFolderColumnName.alias] = alias;
    map[PlaylistFolderColumnName.remarks] = remarks;
    map[PlaylistFolderColumnName.userId] = userId;
    map[PlaylistFolderColumnName.fromLanguage] = fromLanguage;
    map[PlaylistFolderColumnName.learningLanguage] = learningLanguage;
    map[PlaylistFolderColumnName.sortOrder] = sortOrder;
    map[PlaylistFolderColumnName.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[PlaylistFolderColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[PlaylistFolderColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
