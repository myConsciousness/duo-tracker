// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/tips_and_notes_column.dart';

class TipsAndNotes {
  int id = -1;
  String skillId;
  String content;
  bool bookmarked;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [TipsAndNotes].
  TipsAndNotes.empty()
      : _empty = true,
        skillId = '',
        content = '',
        bookmarked = false,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [TipsAndNotes] based on the parameters.
  TipsAndNotes.from({
    this.id = -1,
    required this.skillId,
    required this.content,
    required this.bookmarked,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [TipsAndNotes] based on the [map] passed as an argument.
  factory TipsAndNotes.fromMap(Map<String, dynamic> map) => TipsAndNotes.from(
        id: map[TipsAndNotesColumn.id],
        skillId: map[TipsAndNotesColumn.skillId],
        content: map[TipsAndNotesColumn.content],
        bookmarked: map[TipsAndNotesColumn.bookmarked] == BooleanText.true_,
        deleted: map[TipsAndNotesColumn.deleted] == BooleanText.true_,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[TipsAndNotesColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[TipsAndNotesColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [TipsAndNotes] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[TipsAndNotesColumn.skillId] = skillId;
    map[TipsAndNotesColumn.content] = content;
    map[TipsAndNotesColumn.bookmarked] =
        bookmarked ? BooleanText.true_ : BooleanText.false_;
    map[TipsAndNotesColumn.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[TipsAndNotesColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[TipsAndNotesColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
