// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class TipAndNoteRepository extends Repository<TipAndNote> {
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