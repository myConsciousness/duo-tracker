// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/learned_word_folder_column_name.dart';

class LearnedWordFolder {
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

  /// Returns the empty instance of [LearnedWordFolder].
  LearnedWordFolder.empty()
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

  /// Returns the new instance of [LearnedWordFolder] based on the parameters.
  LearnedWordFolder.from({
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

  /// Returns the new instance of [LearnedWordFolder] based on the [map] passed as an argument.
  factory LearnedWordFolder.fromMap(Map<String, dynamic> map) =>
      LearnedWordFolder.from(
        id: map[LearnedWordFolderColumnName.id],
        parentFolderId: map[LearnedWordFolderColumnName.parentFolderId],
        name: map[LearnedWordFolderColumnName.name],
        alias: map[LearnedWordFolderColumnName.alias],
        remarks: map[LearnedWordFolderColumnName.remarks],
        userId: map[LearnedWordFolderColumnName.userId],
        fromLanguage: map[LearnedWordFolderColumnName.fromLanguage],
        learningLanguage: map[LearnedWordFolderColumnName.learningLanguage],
        sortOrder: map[LearnedWordFolderColumnName.sortOrder],
        deleted: map[LearnedWordFolderColumnName.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordFolderColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordFolderColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [LearnedWordFolder] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[LearnedWordFolderColumnName.parentFolderId] = parentFolderId;
    map[LearnedWordFolderColumnName.name] = name;
    map[LearnedWordFolderColumnName.alias] = alias;
    map[LearnedWordFolderColumnName.remarks] = remarks;
    map[LearnedWordFolderColumnName.userId] = userId;
    map[LearnedWordFolderColumnName.fromLanguage] = fromLanguage;
    map[LearnedWordFolderColumnName.learningLanguage] = learningLanguage;
    map[LearnedWordFolderColumnName.sortOrder] = sortOrder;
    map[LearnedWordFolderColumnName.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordFolderColumnName.createdAt] =
        createdAt.millisecondsSinceEpoch;
    map[LearnedWordFolderColumnName.updatedAt] =
        updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
