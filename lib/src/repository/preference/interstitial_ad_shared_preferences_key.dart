// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

enum InterstitialAdSharedPreferencesKey {
  /// The count of open app
  countOpenApp,

  /// The immediately
  immediately,
}

extension KeyFeature on InterstitialAdSharedPreferencesKey {
  String get key {
    switch (this) {
      case InterstitialAdSharedPreferencesKey.countOpenApp:
        return 'count_open_app';
      case InterstitialAdSharedPreferencesKey.immediately:
        return 'interstitial_immediately';
    }
  }

  int get limitCount {
    switch (this) {
      case InterstitialAdSharedPreferencesKey.countOpenApp:
        return 3;
      case InterstitialAdSharedPreferencesKey.immediately:
        return 1;
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
