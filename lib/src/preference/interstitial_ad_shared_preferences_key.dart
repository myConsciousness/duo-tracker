// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

enum InterstitialAdSharedPreferencesKey {
  /// The count of open app
  countOpenApp,

  /// The count misc sctions
  countMiscActions,
}

extension KeyFeature on InterstitialAdSharedPreferencesKey {
  String get key {
    switch (this) {
      case InterstitialAdSharedPreferencesKey.countOpenApp:
        return 'count_open_app';
      case InterstitialAdSharedPreferencesKey.countMiscActions:
        return 'count_misc_actions';
    }
  }

  int get limitCount {
    switch (this) {
      case InterstitialAdSharedPreferencesKey.countOpenApp:
        return 3;
      case InterstitialAdSharedPreferencesKey.countMiscActions:
        return 3;
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
