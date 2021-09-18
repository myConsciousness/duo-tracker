// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';

class WordFilter {
  /// Checks whether or not the word can be displayed based on the given arguments.
  static bool execute({
    required OverviewTabType overviewTabType,
    required LearnedWord learnedWord,
    required bool searching,
    required String searchWord,
  }) =>
      _checkOverviewTabType(
        overviewTabType: overviewTabType,
        learnedWord: learnedWord,
      ) &&
      _checkSearchWord(
        learnedWord: learnedWord,
        searching: searching,
        searchWord: searchWord,
      );

  static bool _checkOverviewTabType({
    required OverviewTabType overviewTabType,
    required LearnedWord learnedWord,
  }) {
    switch (overviewTabType) {
      case OverviewTabType.all:
        return !learnedWord.completed && !learnedWord.deleted;
      case OverviewTabType.bookmarked:
        return learnedWord.bookmarked &&
            !learnedWord.completed &&
            !learnedWord.deleted;
      case OverviewTabType.completed:
        return learnedWord.completed && !learnedWord.deleted;
      case OverviewTabType.trash:
        return learnedWord.deleted;
    }
  }

  static bool _checkSearchWord({
    required LearnedWord learnedWord,
    required bool searching,
    required String searchWord,
  }) {
    if (searching && searchWord.isNotEmpty) {
      return learnedWord.wordString.contains(searchWord);
    }

    return true;
  }
}
