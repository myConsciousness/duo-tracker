// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:flutter/material.dart';

class InterstitialAdUtils {
  static Future<void> showInterstitialAd({
    BuildContext? context,
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
        await interstitialAdResolver.showInterstitialAd(
            onAdShowed: (reward) async {
          if (context != null) {
            final currentPoint =
                await CommonSharedPreferencesKey.rewardPoint.getInt();
            await CommonSharedPreferencesKey.rewardPoint
                .setInt(currentPoint + reward);

            InfoSnackbar.from(context: context).show(
                content:
                    'Thank you for looking at ad! $reward points were given as a reward!');
          }
        });

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
