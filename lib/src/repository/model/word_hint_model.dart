// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/word_hint_column.dart';

class WordHint {
  int id = -1;
  String wordId;
  String userId;
  String learningLanguage;
  String fromLanguage;
  String formalLearningLanguage;
  String formalFromLanguage;
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
        formalLearningLanguage = '',
        formalFromLanguage = '',
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
    required this.formalLearningLanguage,
    required this.formalFromLanguage,
    required this.value,
    required this.hint,
    this.sortOrder = -1,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [WordHint] based on the [map] passed as an argument.
  factory WordHint.fromMap(Map<String, dynamic> map) => WordHint.from(
        id: map[WordHintColumn.id],
        wordId: map[WordHintColumn.wordId],
        userId: map[WordHintColumn.userId],
        learningLanguage: map[WordHintColumn.learningLanguage],
        fromLanguage: map[WordHintColumn.fromLanguage],
        formalLearningLanguage: map[WordHintColumn.formalLearningLanguage],
        formalFromLanguage: map[WordHintColumn.formalFromLanguage],
        value: map[WordHintColumn.value],
        hint: map[WordHintColumn.hint],
        sortOrder: map[WordHintColumn.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[WordHintColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[WordHintColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [WordHint] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[WordHintColumn.wordId] = wordId;
    map[WordHintColumn.userId] = userId;
    map[WordHintColumn.learningLanguage] = learningLanguage;
    map[WordHintColumn.fromLanguage] = fromLanguage;
    map[WordHintColumn.formalLearningLanguage] = formalLearningLanguage;
    map[WordHintColumn.formalFromLanguage] = formalFromLanguage;
    map[WordHintColumn.value] = value;
    map[WordHintColumn.hint] = hint;
    map[WordHintColumn.sortOrder] = sortOrder;
    map[WordHintColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[WordHintColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
