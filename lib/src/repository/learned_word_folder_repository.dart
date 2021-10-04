// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class LearnedWordFolderRepository
    extends Repository<LearnedWordFolder> {
  Future<List<LearnedWordFolder>>
      findByUserIdAndFromLanguageAndLearningLanguage({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });
}
