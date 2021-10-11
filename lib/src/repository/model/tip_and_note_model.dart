// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/tip_and_note_column.dart';

class TipAndNote {
  int id = -1;
  String skillId;
  String skillName;
  String content;
  String contentSummary;
  String userId;
  String fromLanguage;
  String learningLanguage;
  String formalFromLanguage;
  String formalLearningLanguage;
  int sortOrder;
  bool bookmarked;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [TipAndNote].
  TipAndNote.empty()
      : _empty = true,
        skillId = '',
        skillName = '',
        content = '',
        contentSummary = '',
        userId = '',
        fromLanguage = '',
        learningLanguage = '',
        formalFromLanguage = '',
        formalLearningLanguage = '',
        sortOrder = -1,
        bookmarked = false,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [TipAndNote] based on the parameters.
  TipAndNote.from({
    this.id = -1,
    required this.skillId,
    required this.skillName,
    required this.content,
    required this.contentSummary,
    required this.userId,
    required this.fromLanguage,
    required this.learningLanguage,
    required this.formalFromLanguage,
    required this.formalLearningLanguage,
    this.sortOrder = -1,
    required this.bookmarked,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [TipAndNote] based on the [map] passed as an argument.
  factory TipAndNote.fromMap(Map<String, dynamic> map) => TipAndNote.from(
        id: map[TipAndNoteColumn.id],
        skillId: map[TipAndNoteColumn.skillId],
        skillName: map[TipAndNoteColumn.skillName],
        content: map[TipAndNoteColumn.content],
        contentSummary: map[TipAndNoteColumn.contentSummary],
        userId: map[TipAndNoteColumn.userId],
        fromLanguage: map[TipAndNoteColumn.fromLanguage],
        learningLanguage: map[TipAndNoteColumn.learningLanguage],
        formalFromLanguage: map[TipAndNoteColumn.formalFromLanguage],
        formalLearningLanguage: map[TipAndNoteColumn.formalLearningLanguage],
        sortOrder: map[TipAndNoteColumn.sortOrder],
        bookmarked: map[TipAndNoteColumn.bookmarked] == BooleanText.true_,
        deleted: map[TipAndNoteColumn.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[TipAndNoteColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[TipAndNoteColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [TipAndNote] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[TipAndNoteColumn.skillId] = skillId;
    map[TipAndNoteColumn.skillName] = skillName;
    map[TipAndNoteColumn.content] = content;
    map[TipAndNoteColumn.contentSummary] = contentSummary;
    map[TipAndNoteColumn.userId] = userId;
    map[TipAndNoteColumn.fromLanguage] = fromLanguage;
    map[TipAndNoteColumn.learningLanguage] = learningLanguage;
    map[TipAndNoteColumn.formalFromLanguage] = formalFromLanguage;
    map[TipAndNoteColumn.formalLearningLanguage] = formalLearningLanguage;
    map[TipAndNoteColumn.sortOrder] = sortOrder;
    map[TipAndNoteColumn.bookmarked] =
        bookmarked ? BooleanText.true_ : BooleanText.false_;
    map[TipAndNoteColumn.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[TipAndNoteColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[TipAndNoteColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
