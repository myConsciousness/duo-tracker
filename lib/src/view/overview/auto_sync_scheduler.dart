// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

class AutoSyncScheduler {
  Future<bool> canAutoSync() async {
    final useAutoSync = await CommonSharedPreferencesKey.overviewUseAutoSync
        .getBool(defaultValue: true);

    if (!useAutoSync) {
      return false;
    }

    final interval = await CommonSharedPreferencesKey.overviewAutoSyncInterval
        .getInt(defaultValue: 1);

    return (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(
                await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview
                    .getInt()))
            .inDays
            .abs() >=
        interval);
  }
}
