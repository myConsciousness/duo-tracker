// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

enum InterstitialAdSharedPreferencesKey {
  /// The count of open app
  countOpenApp,

  /// The count sync words
  countSyncWords,

  /// The count search words
  countSearchWords,

  /// The count sort words
  countSortWords,

  /// The filter words
  countFilterWords,

  /// The count adjust goals
  countAdjustGoals,

  /// The count sync user
  countSyncUser,

  /// The count show tip and note
  countShowTipAndNote,

  /// The count play audio
  countPlayAudio,

  /// The immediately
  immediately,
}

extension KeyFeature on InterstitialAdSharedPreferencesKey {
  String get key {
    switch (this) {
      case InterstitialAdSharedPreferencesKey.countOpenApp:
        return 'count_open_app';
      case InterstitialAdSharedPreferencesKey.countSyncWords:
        return 'count_sync_words';
      case InterstitialAdSharedPreferencesKey.countSearchWords:
        return 'count_search_words';
      case InterstitialAdSharedPreferencesKey.countSortWords:
        return 'count_sort_words';
      case InterstitialAdSharedPreferencesKey.countFilterWords:
        return 'count_filter_words';
      case InterstitialAdSharedPreferencesKey.countAdjustGoals:
        return 'count_adjust_goals';
      case InterstitialAdSharedPreferencesKey.countSyncUser:
        return 'count_sync_user';
      case InterstitialAdSharedPreferencesKey.countShowTipAndNote:
        return 'count_show_tip_and_note';
      case InterstitialAdSharedPreferencesKey.countPlayAudio:
        return 'count_play_audio';
      case InterstitialAdSharedPreferencesKey.immediately:
        return 'interstitial_immediately';
    }
  }

  int get limitCount {
    switch (this) {
      case InterstitialAdSharedPreferencesKey.countOpenApp:
        return 3;
      case InterstitialAdSharedPreferencesKey.countSyncWords:
        return 3;
      case InterstitialAdSharedPreferencesKey.countSearchWords:
        return 3;
      case InterstitialAdSharedPreferencesKey.countSortWords:
        return 0;
      case InterstitialAdSharedPreferencesKey.countFilterWords:
        return 0;
      case InterstitialAdSharedPreferencesKey.countAdjustGoals:
        return 0;
      case InterstitialAdSharedPreferencesKey.countSyncUser:
        return 0;
      case InterstitialAdSharedPreferencesKey.countShowTipAndNote:
        return 3;
      case InterstitialAdSharedPreferencesKey.countPlayAudio:
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
