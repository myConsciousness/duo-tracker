// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/const/column/folder_column.dart';
import 'package:duo_tracker/src/repository/utils/boolean_text.dart';
import 'package:duo_tracker/src/view/folder/folder_type.dart';

class Folder {
  int id = -1;
  int parentFolderId;
  FolderType folderType;
  String name;
  String remarks;
  String userId;
  String fromLanguage;
  String learningLanguage;
  String formalFromLanguage;
  String formalLearningLanguage;
  int sortOrder;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [Folder].
  Folder.empty()
      : _empty = true,
        parentFolderId = -1,
        folderType = FolderType.word,
        name = '',
        remarks = '',
        userId = '',
        fromLanguage = '',
        learningLanguage = '',
        formalFromLanguage = '',
        formalLearningLanguage = '',
        sortOrder = -1,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [Folder] based on the parameters.
  Folder.from({
    this.id = -1,
    required this.parentFolderId,
    required this.folderType,
    required this.name,
    required this.remarks,
    required this.userId,
    required this.fromLanguage,
    required this.learningLanguage,
    required this.formalFromLanguage,
    required this.formalLearningLanguage,
    this.sortOrder = -1,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [Folder] based on the [map] passed as an argument.
  factory Folder.fromMap(Map<String, dynamic> map) => Folder.from(
        id: map[FolderColumn.id],
        parentFolderId: map[FolderColumn.parentFolderId],
        folderType: FolderTypeExt.toEnum(code: map[FolderColumn.folderType]),
        name: map[FolderColumn.name],
        remarks: map[FolderColumn.remarks],
        userId: map[FolderColumn.userId],
        fromLanguage: map[FolderColumn.fromLanguage],
        learningLanguage: map[FolderColumn.learningLanguage],
        formalFromLanguage: map[FolderColumn.formalFromLanguage],
        formalLearningLanguage: map[FolderColumn.formalLearningLanguage],
        sortOrder: map[FolderColumn.sortOrder],
        deleted: map[FolderColumn.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[FolderColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[FolderColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [Folder] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[FolderColumn.parentFolderId] = parentFolderId;
    map[FolderColumn.folderType] = folderType.code;
    map[FolderColumn.name] = name;
    map[FolderColumn.remarks] = remarks;
    map[FolderColumn.userId] = userId;
    map[FolderColumn.fromLanguage] = fromLanguage;
    map[FolderColumn.learningLanguage] = learningLanguage;
    map[FolderColumn.formalFromLanguage] = formalFromLanguage;
    map[FolderColumn.formalLearningLanguage] = formalLearningLanguage;
    map[FolderColumn.sortOrder] = sortOrder;
    map[FolderColumn.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[FolderColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[FolderColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
