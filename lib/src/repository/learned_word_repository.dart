// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/repository.dart';

abstract class LearnedWordRepository extends Repository<LearnedWord> {
  Future<List<LearnedWord>> findByUserIdAndNotDeleted(
    String userId,
  );

  Future<LearnedWord> findByWordIdAndUserId(
    String wordId,
    String userId,
  );

  Future<void> deleteByWordIdAndUserId(
    String wordId,
    String userId,
  );

  Future<LearnedWord> replaceByWordIdAndUserId(LearnedWord learnedWord);
}
