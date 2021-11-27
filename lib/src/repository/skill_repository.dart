// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/skill_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class SkillRepository extends Repository<Skill> {
  Future<Skill> findByName({
    required String name,
  });

  Future<void> insertAll({
    required List<Skill> skills,
  });
}
