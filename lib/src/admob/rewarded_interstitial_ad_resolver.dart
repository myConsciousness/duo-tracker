// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
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

  /// Returns [true] if rewarded ad is already loaded, otherwise [false].
  bool get adLoaded => _rewardedAd != null;

  Future<void> loadRewardedAd() async => await RewardedAd.load(
        adUnitId: DuoTrackerAdmobUnitIds.getInstance().releaseRewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (final RewardedAd rewardedAd) {
            _rewardedAd = rewardedAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final LoadAdError loadAdError) async {
            _rewardedAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 10) {
              await loadRewardedAd();
            }
          },
        ),
      );

  Future<void> showRewardedAd() async {
    if (_rewardedAd == null) {
      await loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (final RewardedAd rewardedAd) {},
      onAdDismissedFullScreenContent: (final RewardedAd rewardedAd) async {
        await rewardedAd.dispose();
      },
      onAdFailedToShowFullScreenContent:
          (final RewardedAd rewardedAd, final AdError adError) async {
        await rewardedAd.dispose();
        await loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
        onUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
      final currentPoint = await CommonSharedPreferencesKey.rewardPoint.getInt(
        defaultValue: 0,
      );

      await CommonSharedPreferencesKey.rewardPoint.setInt(
        currentPoint + reward.amount.toInt(),
      );
    });

    _rewardedAd = null;

    /// Reload next ad
    await loadRewardedAd();
  }
}
