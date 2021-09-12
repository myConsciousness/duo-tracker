// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Course {
  int id = -1;
  String courseId;
  String title;
  String learningLanguage;
  String fromLanguage;
  int xp;
  int crowns;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [Course].
  Course.empty()
      : _empty = true,
        courseId = '',
        title = '',
        learningLanguage = '',
        fromLanguage = '',
        xp = 0,
        crowns = 0;

  /// Returns the new instance of [Course] based on the parameters.
  Course.from({
    this.id = -1,
    required this.courseId,
    required this.title,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.xp,
    required this.crowns,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [Course] based on the [map] passed as an argument.
  factory Course.fromMap(Map<String, dynamic> map) => Course.from(
        id: map[_ColumnName.id],
        courseId: map[_ColumnName.courseId],
        title: map[_ColumnName.title],
        learningLanguage: map[_ColumnName.learningLanguage],
        fromLanguage: map[_ColumnName.fromLanguage],
        xp: map[_ColumnName.xp],
        crowns: map[_ColumnName.crowns],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [VoiceConfiguration] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.courseId] = courseId;
    map[_ColumnName.title] = title;
    map[_ColumnName.learningLanguage] = learningLanguage;
    map[_ColumnName.fromLanguage] = fromLanguage;
    map[_ColumnName.xp] = xp;
    map[_ColumnName.crowns] = crowns;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [Course] repository.
class _ColumnName {
  static const id = 'ID';
  static const courseId = 'COURSE_ID';
  static const title = 'TITLE';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const xp = 'XP';
  static const crowns = 'CROWNS';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
