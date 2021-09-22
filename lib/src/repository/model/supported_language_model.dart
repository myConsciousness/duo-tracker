// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/supported_language_column_name.dart';

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
        id: map[SupportedLanguageColumnName.id],
        fromLanguage: map[SupportedLanguageColumnName.fromLanguage],
        learningLanguage: map[SupportedLanguageColumnName.learningLanguage],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[SupportedLanguageColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[SupportedLanguageColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [SupportedLanguage] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[SupportedLanguageColumnName.fromLanguage] = fromLanguage;
    map[SupportedLanguageColumnName.learningLanguage] = learningLanguage;
    map[SupportedLanguageColumnName.createdAt] =
        createdAt.millisecondsSinceEpoch;
    map[SupportedLanguageColumnName.updatedAt] =
        updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
