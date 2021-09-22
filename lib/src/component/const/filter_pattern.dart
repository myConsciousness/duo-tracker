// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/learned_word_column_name.dart';

enum FilterPattern {
  // The none
  none,

  /// The lesson
  lesson,

  /// The strength
  strength,

  /// The pos
  pos,

  /// The infinitive
  infinitive,

  /// The gender
  gender,
}

extension FilterItemExt on FilterPattern {
  int get code {
    switch (this) {
      case FilterPattern.none:
        return 0;
      case FilterPattern.lesson:
        return 1;
      case FilterPattern.strength:
        return 2;
      case FilterPattern.pos:
        return 3;
      case FilterPattern.infinitive:
        return 4;
      case FilterPattern.gender:
        return 5;
    }
  }

  String get columnName {
    switch (this) {
      case FilterPattern.none:
        throw UnimplementedError();
      case FilterPattern.lesson:
        return LearnedWordColumnName.skillUrlTitle;
      case FilterPattern.strength:
        return LearnedWordColumnName.strengthBars;
      case FilterPattern.pos:
        return LearnedWordColumnName.pos;
      case FilterPattern.infinitive:
        return LearnedWordColumnName.infinitive;
      case FilterPattern.gender:
        return LearnedWordColumnName.gender;
    }
  }
}
