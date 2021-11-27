// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/component/const/filter_pattern.dart';
import 'package:duo_tracker/src/component/const/match_pattern.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_type.dart';

class WordFilter {
  /// Checks whether or not the word can be displayed based on the given arguments.
  static bool execute({
    required OverviewTabType overviewTabType,
    required LearnedWord learnedWord,
    required bool searching,
    required String searchWord,
    required MatchPattern matchPattern,
    required FilterPattern filterPattern,
    required List<String> selectedFilterItems,
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
      ) &&
      _checkFilter(
        learnedWord: learnedWord,
        filterPattern: filterPattern,
        selectedFilterItems: selectedFilterItems,
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

  static bool _checkFilter({
    required LearnedWord learnedWord,
    required FilterPattern filterPattern,
    required List<String> selectedFilterItems,
  }) {
    switch (filterPattern) {
      case FilterPattern.none:
        // No filter was applied
        return true;
      case FilterPattern.lesson:
        return selectedFilterItems.contains(learnedWord.skillUrlTitle);
      case FilterPattern.strength:
        return selectedFilterItems.contains('${learnedWord.strengthBars}');
      case FilterPattern.pos:
        return selectedFilterItems.contains(learnedWord.pos);
      case FilterPattern.infinitive:
        return selectedFilterItems.contains(learnedWord.infinitive);
      case FilterPattern.gender:
        return selectedFilterItems.contains(learnedWord.gender);
    }
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
