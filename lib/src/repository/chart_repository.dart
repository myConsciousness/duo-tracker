// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/chart_data_source_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';
import 'package:duo_tracker/src/view/analysis/proficiency_range.dart';

abstract class ChartRepository extends Repository<ChartDataSource> {
  Future<List<ChartDataSource>> computeLearningScoreRatioByUserIdAndTargets({
    required String userId,
    required double targetXpPerDay,
    required double targetWeeklyXp,
    required double targetMontlyXp,
    required double targetStreak,
  });

  Future<List<ChartDataSource>>
      computeSkillProficiencyByProficiencyRangeAndLimit({
    required ProficiencyRange proficiencyRange,
    required int limit,
  });
}
