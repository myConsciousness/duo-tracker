// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/utils/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/skill_column.dart';
import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';

class Skill {
  int id = -1;
  String skillId;
  String name;
  String shortName;
  String urlName;
  bool accessible;
  int iconId;
  int lessons;
  double strength;
  bool lastLessonPerfect;
  int finishedLevels;
  int levels;
  int tipAndNoteId;
  DateTime createdAt;
  DateTime updatedAt;

  /// The tips and notes
  TipAndNote? tipAndNote;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [Skill].
  Skill.empty()
      : _empty = true,
        skillId = '',
        name = '',
        shortName = '',
        urlName = '',
        accessible = false,
        iconId = 0,
        lessons = 0,
        strength = 0.0,
        lastLessonPerfect = false,
        finishedLevels = 0,
        levels = 0,
        tipAndNoteId = -1,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [Skill] based on the parameters.
  Skill.from({
    this.id = -1,
    required this.skillId,
    required this.name,
    required this.shortName,
    required this.urlName,
    required this.accessible,
    required this.iconId,
    required this.lessons,
    required this.strength,
    required this.lastLessonPerfect,
    required this.finishedLevels,
    required this.levels,
    required this.tipAndNoteId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [Skill] based on the [map] passed as an argument.
  factory Skill.fromMap(Map<String, dynamic> map) => Skill.from(
        id: map[SkillColumn.id],
        skillId: map[SkillColumn.skillId],
        name: map[SkillColumn.name],
        shortName: map[SkillColumn.shortName],
        urlName: map[SkillColumn.urlName],
        accessible: map[SkillColumn.accessible] == BooleanText.true_,
        iconId: map[SkillColumn.iconId],
        lessons: map[SkillColumn.lessons],
        strength: map[SkillColumn.strength],
        lastLessonPerfect:
            map[SkillColumn.lastLessonPerfect] == BooleanText.true_,
        finishedLevels: map[SkillColumn.finishedLevels],
        levels: map[SkillColumn.levels],
        tipAndNoteId: map[SkillColumn.tipAndNoteId],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[SkillColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[SkillColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [Skill] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[SkillColumn.skillId] = skillId;
    map[SkillColumn.name] = name;
    map[SkillColumn.shortName] = shortName;
    map[SkillColumn.urlName] = urlName;
    map[SkillColumn.accessible] =
        accessible ? BooleanText.true_ : BooleanText.false_;
    map[SkillColumn.iconId] = iconId;
    map[SkillColumn.lessons] = lessons;
    map[SkillColumn.strength] = strength;
    map[SkillColumn.lastLessonPerfect] =
        lastLessonPerfect ? BooleanText.true_ : BooleanText.false_;
    map[SkillColumn.finishedLevels] = finishedLevels;
    map[SkillColumn.levels] = levels;
    map[SkillColumn.tipAndNoteId] = tipAndNoteId;
    map[SkillColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[SkillColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
