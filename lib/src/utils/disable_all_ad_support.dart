// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/const/product_button_state.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';

class DisableAllAdSupport {
  static Future<bool> isEnabled() async {
    return await DisableFullScreenAdSupport.isEnabled() &&
        await DisableBannerAdSupport.isEnabled();
  }

  static Future<void> clearPurchasedProduct() async {
    await DisableAllAdSupport.clearPurchasedProduct();
    await DisableBannerAdSupport.clearPurchasedProduct();
  }

  static Future<ProductButtonState> getProductButtonState({
    required DisableAdPattern disableAdPattern,
  }) async {
    final disableFullScreenAdTypeCode =
        await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();
    final disableBannerAdTypeCode =
        await CommonSharedPreferencesKey.disableBannerPattern.getInt();

    if (disableFullScreenAdTypeCode == -1 && disableBannerAdTypeCode == -1) {
      return ProductButtonState.enabled;
    }

    final datetimeDisabledFullScreen =
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.getInt();
    final datetimeDisabledBanner =
        await CommonSharedPreferencesKey.datetimeDisabledBanner.getInt();

    if (disableFullScreenAdTypeCode == disableAdPattern.code &&
        disableBannerAdTypeCode == disableAdPattern.code &&
        datetimeDisabledFullScreen == datetimeDisabledBanner) {
      return ProductButtonState.enabled;
    }

    return ProductButtonState.disabled;
  }
}
