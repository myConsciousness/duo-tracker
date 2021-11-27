// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/const/column/course_column.dart';

class Course {
  int id = -1;
  String courseId;
  String title;
  String formalLearningLanguage;
  String formalFromLanguage;
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
        formalLearningLanguage = '',
        formalFromLanguage = '',
        xp = 0,
        crowns = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [Course] based on the parameters.
  Course.from({
    this.id = -1,
    required this.courseId,
    required this.title,
    required this.formalLearningLanguage,
    required this.formalFromLanguage,
    required this.xp,
    required this.crowns,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [Course] based on the [map] passed as an argument.
  factory Course.fromMap(Map<String, dynamic> map) => Course.from(
        id: map[CourseColumn.id],
        courseId: map[CourseColumn.courseId],
        title: map[CourseColumn.title],
        formalLearningLanguage: map[CourseColumn.formalLearningLanguage],
        formalFromLanguage: map[CourseColumn.formalFromLanguage],
        xp: map[CourseColumn.xp],
        crowns: map[CourseColumn.crowns],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[CourseColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[CourseColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [VoiceConfiguration] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[CourseColumn.courseId] = courseId;
    map[CourseColumn.title] = title;
    map[CourseColumn.formalLearningLanguage] = formalLearningLanguage;
    map[CourseColumn.formalFromLanguage] = formalFromLanguage;
    map[CourseColumn.xp] = xp;
    map[CourseColumn.crowns] = crowns;
    map[CourseColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[CourseColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
