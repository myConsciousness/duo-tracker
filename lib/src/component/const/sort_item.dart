// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/const/column/learned_word_column.dart';

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

  String get name {
    switch (this) {
      case SortItem.defaultIndex:
        return 'Index';
      case SortItem.lesson:
        return 'Lesson';
      case SortItem.strength:
        return 'Strength';
      case SortItem.pos:
        return 'Pos';
      case SortItem.infinitive:
        return 'Infinitive';
      case SortItem.gender:
        return 'Gender';
      case SortItem.proficiency:
        return 'Proficiency';
      case SortItem.lastPracticed:
        return 'Last Practiced';
    }
  }

  String get columnName {
    switch (this) {
      case SortItem.defaultIndex:
        return LearnedWordColumn.sortOrder;
      case SortItem.lesson:
        return LearnedWordColumn.skillUrlTitle;
      case SortItem.strength:
        return LearnedWordColumn.strengthBars;
      case SortItem.pos:
        return LearnedWordColumn.pos;
      case SortItem.infinitive:
        return LearnedWordColumn.infinitive;
      case SortItem.gender:
        return LearnedWordColumn.gender;
      case SortItem.proficiency:
        return LearnedWordColumn.strength;
      case SortItem.lastPracticed:
        return LearnedWordColumn.lastPracticedMs;
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
