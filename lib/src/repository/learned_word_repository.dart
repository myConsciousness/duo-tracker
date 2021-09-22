// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/const/filter_pattern.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class LearnedWordRepository extends Repository<LearnedWord> {
  Future<List<LearnedWord>> findByUserIdAndLearningLanguageAndFromLanguage(
    String userId,
    String learningLanguage,
    String fromLanguage,
  );

  Future<LearnedWord> findByWordIdAndUserId(
    String wordId,
    String userId,
  );

  Future<List<String>>
      findDistinctFilterPatternByUserIdAndLearningLanguageAndFromLanguage({
    required FilterPattern filterPattern,
    required String userId,
    required String learningLanguage,
    required String fromLanguage,
  });

  Future<void> deleteByWordIdAndUserId(
    String wordId,
    String userId,
  );

  Future<LearnedWord> replaceById(LearnedWord learnedWord);

  Future<void> replaceSortOrdersByIds(List<LearnedWord> learnedWords);
}
