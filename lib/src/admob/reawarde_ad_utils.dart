// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/rewarded_interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';

class RewardedAdUtils {
  static void showRewarededAd(
      {required RewardedAdSharedPreferencesKey sharedPreferencesKey}) async {
    int count = await sharedPreferencesKey.getInt();

    if (count >= sharedPreferencesKey.limitCount) {
      await sharedPreferencesKey.setInt(0);

      final RewardedAdResolver rewardedAdResolver =
          RewardedAdResolver.getInstance();
      rewardedAdResolver.loadRewardedAd();
      rewardedAdResolver.showRewardedAd();
    } else {
      count++;
      await sharedPreferencesKey.setInt(count);
    }
  }
}
