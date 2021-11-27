// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

enum RewardedAdSharedPreferencesKey {
  /// The reward immediately
  rewardImmediately
}

extension KeyFeature on RewardedAdSharedPreferencesKey {
  String get key {
    switch (this) {
      case RewardedAdSharedPreferencesKey.rewardImmediately:
        return 'reward_immediately';
    }
  }

  int get limitCount {
    switch (this) {
      case RewardedAdSharedPreferencesKey.rewardImmediately:
        return 0;
    }
  }

  Future<bool> setInt(final int value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(key, value);
  }

  Future<int> getInt({int defaultValue = -1}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey(key)) {
      return sharedPreferences.getInt(key) ?? defaultValue;
    }

    return defaultValue;
  }
}
