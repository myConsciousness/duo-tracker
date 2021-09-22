// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/skill_column_name.dart';

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
  DateTime createdAt;
  DateTime updatedAt;

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
        tipsAndNotes = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

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
        id: map[SkillColumnName.id],
        skillId: map[SkillColumnName.skillId],
        name: map[SkillColumnName.name],
        shortName: map[SkillColumnName.shortName],
        urlName: map[SkillColumnName.urlName],
        iconId: map[SkillColumnName.iconId],
        lessons: map[SkillColumnName.lessons],
        strength: map[SkillColumnName.strength],
        lastLessonPerfect:
            map[SkillColumnName.lastLessonPerfect] == BooleanText.true_,
        finishedLevels: map[SkillColumnName.finishedLevels],
        levels: map[SkillColumnName.levels],
        tipsAndNotes: map[SkillColumnName.tipsAndNotes],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[SkillColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[SkillColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [Skill] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[SkillColumnName.skillId] = skillId;
    map[SkillColumnName.name] = name;
    map[SkillColumnName.shortName] = shortName;
    map[SkillColumnName.urlName] = urlName;
    map[SkillColumnName.iconId] = iconId;
    map[SkillColumnName.lessons] = lessons;
    map[SkillColumnName.strength] = strength;
    map[SkillColumnName.lastLessonPerfect] =
        lastLessonPerfect ? BooleanText.true_ : BooleanText.false_;
    map[SkillColumnName.finishedLevels] = finishedLevels;
    map[SkillColumnName.levels] = levels;
    map[SkillColumnName.tipsAndNotes] = tipsAndNotes;
    map[SkillColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[SkillColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
