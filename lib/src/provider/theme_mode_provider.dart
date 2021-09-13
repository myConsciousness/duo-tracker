// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';

class ThemeModeProvider with ChangeNotifier {
  ThemeModeProvider() {
    _asyncInit();
  }

  bool _appliedDarkTheme = false;

  Future<void> _asyncInit() async {
    notify(
        appliedDarkTheme:
            await CommonSharedPreferencesKey.applyDarkTheme.getBool());
  }

  bool get appliedDarkTheme => _appliedDarkTheme;

  Future<void> notify({required final bool appliedDarkTheme}) async {
    _appliedDarkTheme = appliedDarkTheme;
    await CommonSharedPreferencesKey.applyDarkTheme.setBool(appliedDarkTheme);
    super.notifyListeners();
  }
}
