// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/tips_and_notes_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class TipsAndNotesRepository extends Repository<TipsAndNotes> {
  Future<int> findIdBySkillIdAndContent({
    required String skillId,
    required String content,
  });

  Future<bool> checkExistBySkillIdAndContent({
    required String skillId,
    required String content,
  });
}
