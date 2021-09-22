// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/learned_word_column_name.dart';

/// The enum that represents sort item.
enum SortItem {
  defaultIndex,
  lesson,
  strength,
  pos,
  infinitive,
  gender,
  proficiency,
  lastPracticed,
}

extension SortItemExt on SortItem {
  int get code {
    switch (this) {
      case SortItem.defaultIndex:
        return 0;
      case SortItem.lesson:
        return 1;
      case SortItem.strength:
        return 2;
      case SortItem.pos:
        return 3;
      case SortItem.infinitive:
        return 4;
      case SortItem.gender:
        return 5;
      case SortItem.proficiency:
        return 6;
      case SortItem.lastPracticed:
        return 7;
    }
  }

  String get columnName {
    switch (this) {
      case SortItem.defaultIndex:
        return LearnedWordColumnName.sortOrder;
      case SortItem.lesson:
        return LearnedWordColumnName.skillUrlTitle;
      case SortItem.strength:
        return LearnedWordColumnName.strengthBars;
      case SortItem.pos:
        return LearnedWordColumnName.pos;
      case SortItem.infinitive:
        return LearnedWordColumnName.infinitive;
      case SortItem.gender:
        return LearnedWordColumnName.gender;
      case SortItem.proficiency:
        return LearnedWordColumnName.strength;
      case SortItem.lastPracticed:
        return LearnedWordColumnName.lastPracticedMs;
    }
  }

  static SortItem toEnum({required final int code}) {
    for (final SortItem sortItem in SortItem.values) {
      if (code == sortItem.code) {
        return sortItem;
      }
    }

    return SortItem.defaultIndex;
  }
}
