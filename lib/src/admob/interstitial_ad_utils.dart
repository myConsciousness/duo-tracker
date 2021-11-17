// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';

class InterstitialAdUtils {
  static Future<void> showInterstitialAd({
    required InterstitialAdSharedPreferencesKey sharedPreferencesKey,
  }) async {
    if (F.isPaidBuild) {
      return;
    }

    if (await _adDisabled(sharedPreferencesKey: sharedPreferencesKey)) {
      return;
    }

    int count = await sharedPreferencesKey.getInt();

    if (count >= sharedPreferencesKey.limitCount) {
      final interstitialAdResolver = InterstitialAdResolver.getInstance();

      if (interstitialAdResolver.adLoaded) {
        await interstitialAdResolver.showInterstitialAd();
        await sharedPreferencesKey.setInt(0);
      }
    } else {
      count++;
      await sharedPreferencesKey.setInt(count);
    }
  }

  static Future<bool> _adDisabled({
    required InterstitialAdSharedPreferencesKey sharedPreferencesKey,
  }) async {
    if (!await DisableFullScreenAdSupport.isEnabled()) {
      return false;
    }

    if (await DisableFullScreenAdSupport.isExpired()) {
      await DisableFullScreenAdSupport.clearPurchasedProduct();
      return false;
    }

    int count = await sharedPreferencesKey.getInt();

    count++;
    await sharedPreferencesKey.setInt(count);

    return true;
  }
}
