// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';

class InterstitialAdUtils {
  static Future<void> showInterstitialAd({
    required InterstitialAdSharedPreferencesKey sharedPreferencesKey,
  }) async {
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
}
