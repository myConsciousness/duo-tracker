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

  //! The User Information ↑

  //! The Sync Config ↓

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
      case CommonSharedPreferencesKey.usePasscodeLock:
        return 'use_passcode_lock';
      case CommonSharedPreferencesKey.useFingerprintRecognition:
        return 'use_fingerprint_recognition';
      case CommonSharedPreferencesKey.passcode:
        return 'passcode';
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
