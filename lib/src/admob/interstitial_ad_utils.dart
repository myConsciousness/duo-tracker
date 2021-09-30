// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_type.dart';

class InterstitialAdUtils {
  static Future<void> showInterstitialAd({
    required InterstitialAdSharedPreferencesKey sharedPreferencesKey,
  }) async {
    int count = await sharedPreferencesKey.getInt();

    final disableAdPatternCode =
        await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();

    if (disableAdPatternCode != -1) {
      final disableAdPattern =
          DisableAdPatternExt.toEnum(code: disableAdPatternCode);
      final purchasedDatetime = DateTime.fromMillisecondsSinceEpoch(
          await CommonSharedPreferencesKey.datetimeDisabledFullScreen.getInt());

      if (DateTime.now().difference(purchasedDatetime).inMinutes.abs() >
          disableAdPattern.timeLimit) {
        // Disable setting expires.
        await CommonSharedPreferencesKey.disableFullScreenPattern.setInt(-1);
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(-1);
      } else {
        count++;
        await sharedPreferencesKey.setInt(count);
        return;
      }
    }

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
}
