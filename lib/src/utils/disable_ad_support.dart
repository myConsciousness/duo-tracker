// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';

class DisableAdSupport {
  static Future<void> disableFullScreen({
    required DisableAdPattern disableAdPattern,
    DateTime? appliedDateTime,
  }) async {
    appliedDateTime ??= DateTime.now();

    await CommonSharedPreferencesKey.disableFullScreenPattern
        .setInt(disableAdPattern.code);
    await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(
      appliedDateTime.millisecondsSinceEpoch,
    );
  }

  static Future<void> disableBanner({
    required DisableAdPattern disableAdPattern,
    DateTime? appliedDateTime,
  }) async {
    appliedDateTime ??= DateTime.now();

    await CommonSharedPreferencesKey.disableBannerPattern
        .setInt(disableAdPattern.code);
    await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(
      appliedDateTime.millisecondsSinceEpoch,
    );
  }

  static Future<void> disableAll({
    required DisableAdPattern disableAdPattern,
  }) async {
    // Enables for all ads at the same time
    final now = DateTime.now();

    await disableFullScreen(
        disableAdPattern: disableAdPattern, appliedDateTime: now);
    await disableBanner(
        disableAdPattern: disableAdPattern, appliedDateTime: now);
  }
}
