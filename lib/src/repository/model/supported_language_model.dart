// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class SupportedLanguage {
  int id = -1;
  String fromLanguage;
  String learningLanguage;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [SupportedLanguage].
  SupportedLanguage.empty()
      : _empty = true,
        fromLanguage = '',
        learningLanguage = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [SupportedLanguage] based on the parameters.
  SupportedLanguage.from({
    this.id = -1,
    required this.fromLanguage,
    required this.learningLanguage,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [SupportedLanguage] based on the [map] passed as an argument.
  factory SupportedLanguage.fromMap(Map<String, dynamic> map) =>
      SupportedLanguage.from(
        id: map[_ColumnName.id],
        fromLanguage: map[_ColumnName.fromLanguage],
        learningLanguage: map[_ColumnName.learningLanguage],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [SupportedLanguage] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.fromLanguage] = fromLanguage;
    map[_ColumnName.learningLanguage] = learningLanguage;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [SupportedLanguage] repository.
class _ColumnName {
  static const id = 'ID';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
