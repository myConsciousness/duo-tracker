// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/const/schedule_cycle_unit.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

class AutoSyncScheduler {
  Future<bool> canAutoSync() async {
    final useAutoSync = await CommonSharedPreferencesKey.overviewUseAutoSync
        .getBool(defaultValue: true);

    if (!useAutoSync) {
      return false;
    }

    final cycleUnitCode =
        await CommonSharedPreferencesKey.autoSyncCycleUnit.getInt();
    final cycleUnit = ScheduleCycleUnitExt.toEnum(code: cycleUnitCode);
    final cycle =
        await CommonSharedPreferencesKey.autoSyncCycle.getInt(defaultValue: 1);

    final difference = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(
        await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview
            .getInt(),
      ),
    );

    switch (cycleUnit) {
      case ScheduleCycleUnit.day:
        return (difference.inDays.abs() >= cycle);
      case ScheduleCycleUnit.hour:
        return (difference.inHours.abs() >= cycle);
    }
  }
}
