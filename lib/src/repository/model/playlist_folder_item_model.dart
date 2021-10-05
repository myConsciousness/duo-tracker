// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/playlist_folder_item_column_name.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';

class PlaylistFolderItem {
  int id = -1;
  int folderId;
  String wordId;
  String alias;
  String remarks;
  String userId;
  String fromLanguage;
  String learningLanguage;
  int sortOrder;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  /// The learned word linked to word id
  LearnedWord? learnedWord;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [PlaylistFolderItem].
  PlaylistFolderItem.empty()
      : _empty = true,
        folderId = -1,
        wordId = '',
        alias = '',
        remarks = '',
        userId = '',
        fromLanguage = '',
        learningLanguage = '',
        sortOrder = -1,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [PlaylistFolderItem] based on the parameters.
  PlaylistFolderItem.from({
    this.id = -1,
    required this.folderId,
    required this.wordId,
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

  /// Returns the new instance of [PlaylistFolderItem] based on the [map] passed as an argument.
  factory PlaylistFolderItem.fromMap(Map<String, dynamic> map) =>
      PlaylistFolderItem.from(
        id: map[PlaylistFolderItemColumnName.id],
        folderId: map[PlaylistFolderItemColumnName.folderId],
        wordId: map[PlaylistFolderItemColumnName.wordId],
        alias: map[PlaylistFolderItemColumnName.alias],
        remarks: map[PlaylistFolderItemColumnName.remarks],
        userId: map[PlaylistFolderItemColumnName.userId],
        fromLanguage: map[PlaylistFolderItemColumnName.fromLanguage],
        learningLanguage: map[PlaylistFolderItemColumnName.learningLanguage],
        sortOrder: map[PlaylistFolderItemColumnName.sortOrder],
        deleted: map[PlaylistFolderItemColumnName.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[PlaylistFolderItemColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[PlaylistFolderItemColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [PlaylistFolderItem] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[PlaylistFolderItemColumnName.folderId] = folderId;
    map[PlaylistFolderItemColumnName.wordId] = wordId;
    map[PlaylistFolderItemColumnName.alias] = alias;
    map[PlaylistFolderItemColumnName.remarks] = remarks;
    map[PlaylistFolderItemColumnName.userId] = userId;
    map[PlaylistFolderItemColumnName.fromLanguage] = fromLanguage;
    map[PlaylistFolderItemColumnName.learningLanguage] = learningLanguage;
    map[PlaylistFolderItemColumnName.sortOrder] = sortOrder;
    map[PlaylistFolderItemColumnName.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[PlaylistFolderItemColumnName.createdAt] =
        createdAt.millisecondsSinceEpoch;
    map[PlaylistFolderItemColumnName.updatedAt] =
        updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
