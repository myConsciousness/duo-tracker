// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

enum CommonSharedPreferencesKey {
  //! The User Information ↓
  /// The user id
  userId,

  /// The username
  username,

  /// The password
  password,

  /// The current learning language
  currentLearningLanguage,

  /// The current from language
  currentFromLanguage,

  //! The User Information ↑

  //! The Search Config ↓

  /// The match pattern
  matchPattern,

  /// The sort item
  sortItem,

  /// The sort pattern
  sortPattern,

  //! The Search Config ↑

  //! The Score Goals ↓

  /// The score goals daily xp
  scoreGoalsDailyXp,

  /// The score goals weekly xp
  scoreGoalsWeeklyXp,

  /// The score goals monthly xp
  scoreGoalsMonthlyXp,

  /// The score goals streak
  scoreGoalsStreak,

  //! The Score Goals ↑

  //! The Shop Config ↓

  /// The reward point
  rewardPoint,

  /// The disable full screen pattern
  disableFullScreenPattern,

  /// The datetime disabled full screen
  datetimeDisabledFullScreen,

  /// The disable banner pattern
  disableBannerPattern,

  /// The datetime disabled banner
  datetimeDisabledBanner,

  //! The Shop Config ↑

  //! The Sync Config ↓

  /// The datetime last auto synced overview
  datetimeLastAutoSyncedOverview,

  //! The Sync Config ↑

  //! The Settings Config ↓

  /// The apply darke theme
  applyDarkTheme,

  /// The flag represents use auto sync or not
  overviewUseAutoSync,

  /// The overview auto sync interval
  overviewAutoSyncInterval,

  /// The overview default match pattern
  overviewDefaultMatchPattern,

  /// The overview default sort option
  overviewDefaultSortOption,

  //! The Settings Config ↑

  //! The Review Config ↓

  /// The datetime last showed app review
  datetimeLastShowedAppReview,

  //! The Review Config ↑
}

extension KeyFeature on CommonSharedPreferencesKey {
  String get key {
    switch (this) {
      case CommonSharedPreferencesKey.userId:
        return 'user_id';
      case CommonSharedPreferencesKey.username:
        return 'username';
      case CommonSharedPreferencesKey.password:
        return 'password';
      case CommonSharedPreferencesKey.matchPattern:
        return 'match_pattern';
      case CommonSharedPreferencesKey.sortItem:
        return 'sort_item';
      case CommonSharedPreferencesKey.sortPattern:
        return 'sort_pattern';
      case CommonSharedPreferencesKey.scoreGoalsDailyXp:
        return 'score_goals_daily_xp';
      case CommonSharedPreferencesKey.scoreGoalsWeeklyXp:
        return 'score_goals_weekly_xp';
      case CommonSharedPreferencesKey.scoreGoalsMonthlyXp:
        return 'score_goals_monthly_xp';
      case CommonSharedPreferencesKey.scoreGoalsStreak:
        return 'score_goals_streak';
      case CommonSharedPreferencesKey.rewardPoint:
        return 'reward_point';
      case CommonSharedPreferencesKey.disableFullScreenPattern:
        return 'disable_full_screen_pattern';
      case CommonSharedPreferencesKey.datetimeDisabledFullScreen:
        return 'datetime_disabled_full_screen';
      case CommonSharedPreferencesKey.disableBannerPattern:
        return 'disable_banner_pattern';
      case CommonSharedPreferencesKey.datetimeDisabledBanner:
        return 'datetime_disabled_banner';
      case CommonSharedPreferencesKey.currentLearningLanguage:
        return 'current_learning_language';
      case CommonSharedPreferencesKey.currentFromLanguage:
        return 'current_from_language';
      case CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview:
        return 'datetime_last_auto_synced_overview';
      case CommonSharedPreferencesKey.applyDarkTheme:
        return 'apply_dark_theme';
      case CommonSharedPreferencesKey.overviewUseAutoSync:
        return 'overview_use_auto_aync';
      case CommonSharedPreferencesKey.overviewAutoSyncInterval:
        return 'overview_auto_sync_interval';
      case CommonSharedPreferencesKey.overviewDefaultMatchPattern:
        return 'overview_default_match_pattern';
      case CommonSharedPreferencesKey.overviewDefaultSortOption:
        return 'overview_default_sort_option';
      case CommonSharedPreferencesKey.datetimeLastShowedAppReview:
        return 'datetime_last_showed_app_review';
    }
  }

  Future<bool> setString(final String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, value);
  }

  Future<String> getString({String defaultValue = ''}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey(key)) {
      return sharedPreferences.getString(key) ?? defaultValue;
    }

    return defaultValue;
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

  Future<bool> setDouble(final double value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setDouble(key, value);
  }

  Future<double> getDouble({double defaultValue = -1.0}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey(key)) {
      return sharedPreferences.getDouble(key) ?? defaultValue;
    }

    return defaultValue;
  }

  Future<bool> setBool(final bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool({bool defaultValue = false}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey(key)) {
      return sharedPreferences.getBool(key) ?? defaultValue;
    }

    return defaultValue;
  }
}
