// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';

class Skill {
  int id = -1;
  String skillId;
  String name;
  String shortName;
  String urlName;
  int iconId;
  int lessons;
  double strength;
  bool lastLessonPerfect;
  int finishedLevels;
  int levels;
  String tipsAndNotes;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [Skill].
  Skill.empty()
      : _empty = true,
        skillId = '',
        name = '',
        shortName = '',
        urlName = '',
        iconId = 0,
        lessons = 0,
        strength = 0.0,
        lastLessonPerfect = false,
        finishedLevels = 0,
        levels = 0,
        tipsAndNotes = '';

  /// Returns the new instance of [Skill] based on the parameters.
  Skill.from({
    this.id = -1,
    required this.skillId,
    required this.name,
    required this.shortName,
    required this.urlName,
    required this.iconId,
    required this.lessons,
    required this.strength,
    required this.lastLessonPerfect,
    required this.finishedLevels,
    required this.levels,
    required this.tipsAndNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [Skill] based on the [map] passed as an argument.
  factory Skill.fromMap(Map<String, dynamic> map) => Skill.from(
        id: map[_ColumnName.id],
        skillId: map[_ColumnName.skillId],
        name: map[_ColumnName.name],
        shortName: map[_ColumnName.shortName],
        urlName: map[_ColumnName.urlName],
        iconId: map[_ColumnName.iconId],
        lessons: map[_ColumnName.lessons],
        strength: map[_ColumnName.strength],
        lastLessonPerfect:
            map[_ColumnName.lastLessonPerfect] == BooleanText.true_,
        finishedLevels: map[_ColumnName.finishedLevels],
        levels: map[_ColumnName.levels],
        tipsAndNotes: map[_ColumnName.tipsAndNotes],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [Skill] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.skillId] = skillId;
    map[_ColumnName.name] = name;
    map[_ColumnName.shortName] = shortName;
    map[_ColumnName.urlName] = urlName;
    map[_ColumnName.iconId] = iconId;
    map[_ColumnName.lessons] = lessons;
    map[_ColumnName.strength] = strength;
    map[_ColumnName.lastLessonPerfect] =
        lastLessonPerfect ? BooleanText.true_ : BooleanText.false_;
    map[_ColumnName.finishedLevels] = finishedLevels;
    map[_ColumnName.levels] = levels;
    map[_ColumnName.tipsAndNotes] = tipsAndNotes;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [Skill] repository.
class _ColumnName {
  static const id = 'ID';
  static const skillId = 'SKILL_ID';
  static const name = 'NAME';
  static const shortName = 'SHORT_NAME';
  static const urlName = 'URL_NAME';
  static const iconId = 'ICON_ID';
  static const lessons = 'LESSONS';
  static const strength = 'STRENGTH';
  static const lastLessonPerfect = 'LAST_LESSON_PERFECT';
  static const finishedLevels = 'FINISHED_LEVELS';
  static const levels = 'LEVELS';
  static const tipsAndNotes = 'TIPS_AND_NOTES';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
