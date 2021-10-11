// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class TipAndNoteRepository extends Repository<TipAndNote> {
  Future<List<TipAndNote>>
      findByUserIdAndFromLanguageAndLearningLanguageAndDeletedFalse({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<List<TipAndNote>>
      findByUserIdAndFromLanguageAndLearningLanguageAndBookmarkedTrueAndDeletedFalse({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<List<TipAndNote>>
      findByUserIdAndFromLanguageAndLearningLanguageAndDeletedTrue({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<TipAndNote> findBySkillIdAndContentAndUserId({
    required String skillId,
    required String content,
    required String userId,
  });

  Future<TipAndNote> replaceById({
    required TipAndNote tipAndNote,
  });

  Future<int> findIdBySkillIdAndContent({
    required String skillId,
    required String content,
  });

  Future<bool> checkExistBySkillIdAndContent({
    required String skillId,
    required String content,
  });

  Future<void> replaceSortOrdersByIds({
    required List<TipAndNote> tipsAndNotes,
  });
}
