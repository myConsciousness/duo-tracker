// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/dialog/select_search_method_dialog.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';

class WordFilter {
  /// Checks whether or not the word can be displayed based on the given arguments.
  static bool execute({
    required OverviewTabType overviewTabType,
    required LearnedWord learnedWord,
    required bool searching,
    required String searchWord,
    required MatchPattern matchPattern,
  }) =>
      _checkOverviewTabType(
        overviewTabType: overviewTabType,
        learnedWord: learnedWord,
      ) &&
      _checkSearchWord(
        learnedWord: learnedWord,
        searching: searching,
        searchWord: searchWord,
        matchPattern: matchPattern,
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
    required MatchPattern matchPattern,
  }) {
    if (searching && searchWord.isNotEmpty) {
      switch (matchPattern) {
        case MatchPattern.partial:
          return _checkPartialPattern(
              learnedWord: learnedWord, searchWord: searchWord);
        case MatchPattern.exact:
          return _checkExactPattern(
              learnedWord: learnedWord, searchWord: searchWord);
        case MatchPattern.prefix:
          return _checkPrefixPattern(
              learnedWord: learnedWord, searchWord: searchWord);
        case MatchPattern.suffix:
          return _checkSuffixPattern(
              learnedWord: learnedWord, searchWord: searchWord);
      }
    }

    return true;
  }

  static bool _checkPartialPattern({
    required LearnedWord learnedWord,
    required String searchWord,
  }) =>
      learnedWord.wordString.toLowerCase().contains(searchWord.toLowerCase()) ||
      learnedWord.normalizedString
          .toLowerCase()
          .contains(searchWord.toLowerCase());

  static bool _checkExactPattern({
    required LearnedWord learnedWord,
    required String searchWord,
  }) =>
      learnedWord.wordString.toLowerCase() == searchWord.toLowerCase() ||
      learnedWord.normalizedString.toLowerCase() == searchWord.toLowerCase();

  static bool _checkPrefixPattern({
    required LearnedWord learnedWord,
    required String searchWord,
  }) =>
      learnedWord.wordString
          .toLowerCase()
          .startsWith(searchWord.toLowerCase()) ||
      learnedWord.normalizedString
          .toLowerCase()
          .startsWith(searchWord.toLowerCase());

  static bool _checkSuffixPattern({
    required LearnedWord learnedWord,
    required String searchWord,
  }) =>
      learnedWord.wordString.toLowerCase().endsWith(searchWord.toLowerCase()) ||
      learnedWord.normalizedString
          .toLowerCase()
          .endsWith(searchWord.toLowerCase());
}
