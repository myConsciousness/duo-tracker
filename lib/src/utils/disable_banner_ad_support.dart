// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/const/product_banner_button_state.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';

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
        disableAdPattern.limit;
  }

  static Future<void> clearPurchasedProduct() async {
    await CommonSharedPreferencesKey.disableBannerPattern.setInt(-1);
    await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(-1);
  }

  static Future<void> disable({
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

  static Future<ProductBannerButtonState> getProductButtonState({
    required DisableAdPattern disableAdPattern,
  }) async {
    final disableAdTypeCode =
        await CommonSharedPreferencesKey.disableBannerPattern.getInt();

    if (disableAdTypeCode == -1) {
      return ProductBannerButtonState.enabled;
    }

    if (disableAdTypeCode == disableAdPattern.code) {
      return ProductBannerButtonState.enabled;
    }

    return ProductBannerButtonState.disabled;
  }
}
