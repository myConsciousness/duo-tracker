// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class WordHint {
  int id = -1;
  String wordId;
  String userId;
  String learningLanguage;
  String fromLanguage;
  String value;
  String hint;
  int sortOrder;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

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
        sortOrder = -1;

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
        id: map[_ColumnName.id],
        wordId: map[_ColumnName.wordId],
        userId: map[_ColumnName.userId],
        learningLanguage: map[_ColumnName.learningLanguage],
        fromLanguage: map[_ColumnName.fromLanguage],
        value: map[_ColumnName.value],
        hint: map[_ColumnName.hint],
        sortOrder: map[_ColumnName.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [WordHint] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.wordId] = wordId;
    map[_ColumnName.userId] = userId;
    map[_ColumnName.learningLanguage] = learningLanguage;
    map[_ColumnName.fromLanguage] = fromLanguage;
    map[_ColumnName.value] = value;
    map[_ColumnName.hint] = hint;
    map[_ColumnName.sortOrder] = sortOrder;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [WordHint] repository.
class _ColumnName {
  static const id = 'ID';
  static const wordId = 'WORD_ID';
  static const userId = 'USER_ID';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const value = 'VALUE';
  static const hint = 'HINT';
  static const sortOrder = 'SORT_ORDER';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
