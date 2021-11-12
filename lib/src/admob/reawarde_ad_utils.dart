// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/rewarded_interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_type.dart';
import 'package:flutter/material.dart';

class RewardedAdUtils {
  static Future<void> showRewarededAd({
    required BuildContext context,
    required RewardedAdSharedPreferencesKey sharedPreferencesKey,
    required Function(int amount) onRewarded,
    bool showForce = false,
  }) async {
    if (!F.isFreeBuild) {
      return;
    }

    int count = await sharedPreferencesKey.getInt();

    if (!showForce) {
      final disableAdPatternCode =
          await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();

      if (disableAdPatternCode != -1) {
        final disableFullScreenPattern =
            DisableAdPatternExt.toEnum(code: disableAdPatternCode);
        final purchasedDatetime = DateTime.fromMillisecondsSinceEpoch(
            await CommonSharedPreferencesKey.datetimeDisabledFullScreen
                .getInt());

        if (DateTime.now().difference(purchasedDatetime).inMinutes.abs() >
            disableFullScreenPattern.timeLimit) {
          // Disable setting expires.
          await CommonSharedPreferencesKey.disableFullScreenPattern.setInt(-1);
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
}
