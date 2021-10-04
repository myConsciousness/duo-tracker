// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/learned_word_folder_item_column_name.dart';

class LearnedWordFolderItem {
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

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [LearnedWordFolderItem].
  LearnedWordFolderItem.empty()
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

  /// Returns the new instance of [LearnedWordFolderItem] based on the parameters.
  LearnedWordFolderItem.from({
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

  /// Returns the new instance of [LearnedWordFolderItem] based on the [map] passed as an argument.
  factory LearnedWordFolderItem.fromMap(Map<String, dynamic> map) =>
      LearnedWordFolderItem.from(
        id: map[LearnedWordFolderItemColumnName.id],
        folderId: map[LearnedWordFolderItemColumnName.folderId],
        wordId: map[LearnedWordFolderItemColumnName.wordId],
        alias: map[LearnedWordFolderItemColumnName.alias],
        remarks: map[LearnedWordFolderItemColumnName.remarks],
        userId: map[LearnedWordFolderItemColumnName.userId],
        fromLanguage: map[LearnedWordFolderItemColumnName.fromLanguage],
        learningLanguage: map[LearnedWordFolderItemColumnName.learningLanguage],
        sortOrder: map[LearnedWordFolderItemColumnName.sortOrder],
        deleted:
            map[LearnedWordFolderItemColumnName.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordFolderItemColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordFolderItemColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [LearnedWordFolderItem] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[LearnedWordFolderItemColumnName.folderId] = folderId;
    map[LearnedWordFolderItemColumnName.wordId] = wordId;
    map[LearnedWordFolderItemColumnName.alias] = alias;
    map[LearnedWordFolderItemColumnName.remarks] = remarks;
    map[LearnedWordFolderItemColumnName.userId] = userId;
    map[LearnedWordFolderItemColumnName.fromLanguage] = fromLanguage;
    map[LearnedWordFolderItemColumnName.learningLanguage] = learningLanguage;
    map[LearnedWordFolderItemColumnName.sortOrder] = sortOrder;
    map[LearnedWordFolderItemColumnName.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordFolderItemColumnName.createdAt] =
        createdAt.millisecondsSinceEpoch;
    map[LearnedWordFolderItemColumnName.updatedAt] =
        updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
