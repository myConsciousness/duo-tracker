// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_type.dart';

class DisableBannerAdSupport {
  static Future<bool> isEnabled() async {
    final disableAdPatternCode =
        await CommonSharedPreferencesKey.disableBannerPattern.getInt();
    return disableAdPatternCode > -1;
  }

  static Future<bool> isExpired() async {
    final disableAdPatternCode =
        await CommonSharedPreferencesKey.disableBannerPattern.getInt();
    final disableAdPattern =
        DisableAdPatternExt.toEnum(code: disableAdPatternCode);
    final purchasedDatetime = DateTime.fromMillisecondsSinceEpoch(
        await CommonSharedPreferencesKey.datetimeDisabledBanner.getInt());

    return DateTime.now().difference(purchasedDatetime).inMinutes.abs() >
        disableAdPattern.timeLimit;
  }

  static Future<void> clearPurchasedProduct() async {
    await CommonSharedPreferencesKey.disableBannerPattern.setInt(-1);
    await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(-1);
  }
}