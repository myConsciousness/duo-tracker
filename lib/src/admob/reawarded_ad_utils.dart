// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/rewarded_ad.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';

class RewardedAdUtils {
  static Future<void> showRewarededAd({
    required BuildContext context,
    required RewardedAdSharedPreferencesKey key,
    required Function(int amount) onRewarded,
    bool showForce = false,
  }) async {
    if (F.isPaidBuild) {
      return;
    }

    if (!showForce) {
      if (await _adDisabled(key: key)) {
        return;
      }
    }

    int count = await key.getInt();
    count++;

    if (count >= key.limit) {
      final rewardedAd = RewardedAd.instance;

      await rewardedAd.show(
        onRewarded: (amount) async {
          await onRewarded.call(amount);
          await key.setInt(0);
        },
      );
    } else {
      key.setInt(count);
    }
  }

  static Future<bool> _adDisabled({
    required RewardedAdSharedPreferencesKey key,
  }) async {
    if (!await DisableFullScreenAdSupport.isEnabled()) {
      return false;
    }

    if (await DisableFullScreenAdSupport.isExpired()) {
      await DisableFullScreenAdSupport.clearPurchasedProduct();
      return false;
    }

    int count = await key.getInt();

    count++;
    await key.setInt(count);

    return true;
  }
}
