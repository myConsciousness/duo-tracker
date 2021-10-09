// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/folder_item_column.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';

class FolderItem {
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

  /// Returns the empty instance of [FolderItem].
  FolderItem.empty()
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

  /// Returns the new instance of [FolderItem] based on the parameters.
  FolderItem.from({
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

  /// Returns the new instance of [FolderItem] based on the [map] passed as an argument.
  factory FolderItem.fromMap(Map<String, dynamic> map) => FolderItem.from(
        id: map[FolderItemColumn.id],
        folderId: map[FolderItemColumn.folderId],
        wordId: map[FolderItemColumn.wordId],
        alias: map[FolderItemColumn.alias],
        remarks: map[FolderItemColumn.remarks],
        userId: map[FolderItemColumn.userId],
        fromLanguage: map[FolderItemColumn.fromLanguage],
        learningLanguage: map[FolderItemColumn.learningLanguage],
        sortOrder: map[FolderItemColumn.sortOrder],
        deleted: map[FolderItemColumn.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[FolderItemColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[FolderItemColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [FolderItem] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[FolderItemColumn.folderId] = folderId;
    map[FolderItemColumn.wordId] = wordId;
    map[FolderItemColumn.alias] = alias;
    map[FolderItemColumn.remarks] = remarks;
    map[FolderItemColumn.userId] = userId;
    map[FolderItemColumn.fromLanguage] = fromLanguage;
    map[FolderItemColumn.learningLanguage] = learningLanguage;
    map[FolderItemColumn.sortOrder] = sortOrder;
    map[FolderItemColumn.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[FolderItemColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[FolderItemColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
