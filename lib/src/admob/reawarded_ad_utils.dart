// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/rewarded_interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:flutter/material.dart';

class RewardedAdUtils {
  static Future<void> showRewarededAd({
    required BuildContext context,
    required RewardedAdSharedPreferencesKey sharedPreferencesKey,
    required Function(int amount) onRewarded,
    bool showForce = false,
  }) async {
    if (F.isPaidBuild) {
      return;
    }

    if (!showForce) {
      if (await _adDisabled(sharedPreferencesKey: sharedPreferencesKey)) {
        return;
      }
    }

    int count = await sharedPreferencesKey.getInt();

    if (count >= sharedPreferencesKey.limitCount) {
      final rewardedAdResolver = RewardedAdResolver.getInstance();

      if (rewardedAdResolver.adLoaded) {
        await rewardedAdResolver.showRewardedAd(
          onRewarded: onRewarded,
        );
        await sharedPreferencesKey.setInt(0);
      } else {
        await showErrorDialog(
          context: context,
          title: 'No Ads are ready to show',
          content: 'Failed to load ads to get rewards. Please try again.',
        );
      }
    } else {
      count++;
      await sharedPreferencesKey.setInt(count);
    }
  }

  static Future<bool> _adDisabled({
    required RewardedAdSharedPreferencesKey sharedPreferencesKey,
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
