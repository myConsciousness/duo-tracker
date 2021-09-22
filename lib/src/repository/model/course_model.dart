// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/course_column_name.dart';

class Course {
  int id = -1;
  String courseId;
  String title;
  String learningLanguage;
  String fromLanguage;
  int xp;
  int crowns;
  DateTime createdAt;
  DateTime updatedAt;

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
        crowns = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

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
        id: map[CourseColumnName.id],
        courseId: map[CourseColumnName.courseId],
        title: map[CourseColumnName.title],
        learningLanguage: map[CourseColumnName.learningLanguage],
        fromLanguage: map[CourseColumnName.fromLanguage],
        xp: map[CourseColumnName.xp],
        crowns: map[CourseColumnName.crowns],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[CourseColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[CourseColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [VoiceConfiguration] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[CourseColumnName.courseId] = courseId;
    map[CourseColumnName.title] = title;
    map[CourseColumnName.learningLanguage] = learningLanguage;
    map[CourseColumnName.fromLanguage] = fromLanguage;
    map[CourseColumnName.xp] = xp;
    map[CourseColumnName.crowns] = crowns;
    map[CourseColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[CourseColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
