// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/const/product_button_state.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';

class DisableFullScreenAdSupport {
  static Future<bool> isEnabled() async {
    final disableAdPatternCode =
        await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();
    return disableAdPatternCode > -1;
  }

  static Future<bool> isExpired() async {
    final disableAdPatternCode =
        await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();
    final disableAdPattern =
        DisableAdPatternExt.toEnum(code: disableAdPatternCode);
    final purchasedDatetime = DateTime.fromMillisecondsSinceEpoch(
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.getInt());

    return DateTime.now().difference(purchasedDatetime).inMinutes.abs() >
        disableAdPattern.limit;
  }

  static Future<void> clearPurchasedProduct() async {
    await CommonSharedPreferencesKey.disableFullScreenPattern.setInt(-1);
    await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(-1);
  }

  static Future<void> disable({
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

  static Future<ProductButtonState> getProductButtonState({
    required DisableAdPattern disableAdPattern,
  }) async {
    final disableAdTypeCode =
        await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();

    if (disableAdTypeCode == -1) {
      return ProductButtonState.enabled;
    }

    if (disableAdTypeCode == disableAdPattern.code) {
      return ProductButtonState.enabled;
    }

    return ProductButtonState.disabled;
  }
}
