// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/word_hint_column_name.dart';

class WordHint {
  int id = -1;
  String wordId;
  String userId;
  String learningLanguage;
  String fromLanguage;
  String value;
  String hint;
  int sortOrder;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [WordHint].
  WordHint.empty()
      : _empty = true,
        wordId = '',
        userId = '',
        learningLanguage = '',
        fromLanguage = '',
        value = '',
        hint = '',
        sortOrder = -1,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [WordHint] based on the parameters.
  WordHint.from({
    this.id = -1,
    required this.wordId,
    required this.userId,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.value,
    required this.hint,
    this.sortOrder = -1,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [WordHint] based on the [map] passed as an argument.
  factory WordHint.fromMap(Map<String, dynamic> map) => WordHint.from(
        id: map[WordHintColumnName.id],
        wordId: map[WordHintColumnName.wordId],
        userId: map[WordHintColumnName.userId],
        learningLanguage: map[WordHintColumnName.learningLanguage],
        fromLanguage: map[WordHintColumnName.fromLanguage],
        value: map[WordHintColumnName.value],
        hint: map[WordHintColumnName.hint],
        sortOrder: map[WordHintColumnName.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[WordHintColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[WordHintColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [WordHint] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[WordHintColumnName.wordId] = wordId;
    map[WordHintColumnName.userId] = userId;
    map[WordHintColumnName.learningLanguage] = learningLanguage;
    map[WordHintColumnName.fromLanguage] = fromLanguage;
    map[WordHintColumnName.value] = value;
    map[WordHintColumnName.hint] = hint;
    map[WordHintColumnName.sortOrder] = sortOrder;
    map[WordHintColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[WordHintColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
