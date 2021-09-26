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

  //! The Shop Config ↑

  //! The Sync Config ↓

  /// The datetime last auto synced overview
  datetimeLastAutoSyncedOverview,

  //! The Sync Config ↑

  //! The Secutiry Config ↓

  /// The passcode
  passcode,

  //! The Security Config ↑

  //! The Settings Config ↓

  /// The use passcode lock
  usePasscodeLock,

  /// The use fingerprint recognition
  useFingerprintRecognition,

  /// The apply darke theme
  applyDarkTheme,

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
      case CommonSharedPreferencesKey.currentLearningLanguage:
        return 'current_learning_language';
      case CommonSharedPreferencesKey.currentFromLanguage:
        return 'current_from_language';
      case CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview:
        return 'datetime_last_auto_synced_overview';
      case CommonSharedPreferencesKey.usePasscodeLock:
        return 'use_passcode_lock';
      case CommonSharedPreferencesKey.useFingerprintRecognition:
        return 'use_fingerprint_recognition';
      case CommonSharedPreferencesKey.passcode:
        return 'passcode';
      case CommonSharedPreferencesKey.applyDarkTheme:
        return 'apply_dark_theme';
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
