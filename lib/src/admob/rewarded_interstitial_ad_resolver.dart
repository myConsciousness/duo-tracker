// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdResolver {
  /// The internal constructor.
  RewardedAdResolver._internal();

  /// Returns the singleton instance of [RewardedAdResolver].
  factory RewardedAdResolver.getInstance() => _singletonInstance;

  /// The singleton instance of this [RewardedAdResolver].
  static final _singletonInstance = RewardedAdResolver._internal();

  /// The count load attempt
  int _countLoadAttempt = 0;

  /// The rewarded ad
  RewardedAd? _rewardedAd;

  void loadRewardedAd() async => await RewardedAd.load(
        adUnitId: DuoTrackerAdmobUnitIds.getInstance().releaseRewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (final RewardedAd rewardedAd) {
            _rewardedAd = rewardedAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final LoadAdError loadAdError) {
            _rewardedAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 2) {
              loadRewardedAd();
            }
          },
        ),
      );

  void showRewardedAd() {
    if (_rewardedAd == null) {
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (final RewardedAd rewardedAd) {},
      onAdDismissedFullScreenContent: (final RewardedAd rewardedAd) {
        rewardedAd.dispose();
      },
      onAdFailedToShowFullScreenContent:
          (final RewardedAd rewardedAd, final AdError adError) {
        rewardedAd.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print("reqareded!");
    });

    _rewardedAd = null;
  }
}
