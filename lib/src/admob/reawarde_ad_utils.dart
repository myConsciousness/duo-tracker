// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/rewarded_interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/view/shop/disable_full_screen_type.dart';
import 'package:flutter/material.dart';

class RewardedAdUtils {
  static Future<void> showRewarededAd({
    required BuildContext context,
    required RewardedAdSharedPreferencesKey sharedPreferencesKey,
    bool showForce = false,
  }) async {
    int count = await sharedPreferencesKey.getInt();

    if (!showForce) {
      final disableFullScreenTypeCode =
          await CommonSharedPreferencesKey.disableFullScreenType.getInt();

      if (disableFullScreenTypeCode != -1) {
        final disableFullScreenType =
            DisableFullScreenTypeExt.toEnum(code: disableFullScreenTypeCode);
        final purchasedDatetime = DateTime.fromMillisecondsSinceEpoch(
            await CommonSharedPreferencesKey.datetimeDisabledFullScreen
                .getInt());

        if (purchasedDatetime.difference(DateTime.now()).inMinutes >
            disableFullScreenType.timeLimit) {
          // Disable setting expires.
          await CommonSharedPreferencesKey.disableFullScreenType.setInt(-1);
          await CommonSharedPreferencesKey.datetimeDisabledFullScreen
              .setInt(-1);
        } else {
          count++;
          await sharedPreferencesKey.setInt(count);
          return;
        }
      }
    }

    if (count >= sharedPreferencesKey.limitCount) {
      final rewardedAdResolver = RewardedAdResolver.getInstance();

      if (rewardedAdResolver.adLoaded) {
        await rewardedAdResolver.showRewardedAd();
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
}
