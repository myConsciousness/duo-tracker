// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

class ThemeModeProvider with ChangeNotifier {
  /// The internal constructor.
  ThemeModeProvider._internal();

  /// Returns the singleton instance of [ThemeModeProvider].
  factory ThemeModeProvider.getInstance() => _singletonInstance;

  /// The singleton instance of this [ThemeModeProvider].
  static final _singletonInstance = ThemeModeProvider._internal();

  bool _appliedDarkTheme = false;

  Future<void> initialize() async {
    await notify(
      appliedDarkTheme:
          await CommonSharedPreferencesKey.applyDarkTheme.getBool(),
    );
  }

  bool get appliedDarkTheme => _appliedDarkTheme;

  Future<void> notify({
    required final bool appliedDarkTheme,
  }) async {
    _appliedDarkTheme = appliedDarkTheme;
    await CommonSharedPreferencesKey.applyDarkTheme.setBool(appliedDarkTheme);
    super.notifyListeners();
  }
}
