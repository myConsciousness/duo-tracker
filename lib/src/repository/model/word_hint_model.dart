// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class WordHint {
  int id = -1;
  String wordId;
  String userId;
  String hint;
  String learningLanguage;
  String fromLanguage;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [WordHint].
  WordHint.empty()
      : this._empty = true,
        this.wordId = '',
        this.userId = '',
        this.learningLanguage = '',
        this.fromLanguage = '',
        this.hint = '';

  /// Returns the new instance of [WordHint] based on the parameters.
  WordHint.from({
    this.id = -1,
    required this.wordId,
    required this.userId,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.hint,
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
        hint: map[_ColumnName.hint],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] == null ? 0 : map[_ColumnName.createdAt],
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] == null ? 0 : map[_ColumnName.updatedAt],
        ),
      );

  /// Returns this [WordHint] model as [Map].
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map[_ColumnName.wordId] = this.wordId;
    map[_ColumnName.userId] = this.userId;
    map[_ColumnName.learningLanguage] = this.learningLanguage;
    map[_ColumnName.fromLanguage] = this.fromLanguage;
    map[_ColumnName.hint] = this.hint;
    map[_ColumnName.createdAt] = this.createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = this.updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => this._empty;
}

/// The internal const class that manages the column name of [WordHint] repository.
class _ColumnName {
  static const id = 'ID';
  static const wordId = 'WORD_ID';
  static const userId = 'USER_ID';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const hint = 'HINT';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
