// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

// Project imports:
import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';

class RewardedAd {
  /// The internal constructor.
  RewardedAd._internal();

  /// Returns the singleton instance of [RewardedAd].
  static RewardedAd get instance => _singletonInstance;

  /// The singleton instance of this [RewardedAd].
  static final _singletonInstance = RewardedAd._internal();

  /// The count load attempt
  int _countLoadAttempt = 0;

  /// The rewarded ad
  admob.RewardedAd? _rewardedAd;

  /// Returns true if rewarded ad is already loaded, otherwise false.
  bool get isLoaded => _rewardedAd != null;

  Future<void> load() async => await admob.RewardedAd.load(
        adUnitId: DuoTrackerAdmobUnitIds.getInstance().releaseRewarded,
        request: const admob.AdRequest(),
        rewardedAdLoadCallback: admob.RewardedAdLoadCallback(
          onAdLoaded: (final rewardedAd) {
            _rewardedAd = rewardedAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final loadAdError) async {
            _rewardedAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 10) {
              await load();
            }
          },
        ),
      );

  Future<void> show({
    required Function(int amount) onRewarded,
  }) async {
    if (!isLoaded) {
      await load();
    }

    if (isLoaded) {
      _rewardedAd!.fullScreenContentCallback = admob.FullScreenContentCallback(
        onAdShowedFullScreenContent: (final rewardedAd) {},
        onAdDismissedFullScreenContent: (final rewardedAd) async {
          await rewardedAd.dispose();
        },
        onAdFailedToShowFullScreenContent:
            (final rewardedAd, final adError) async {
          await rewardedAd.dispose();
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) =>
            onRewarded.call(reward.amount.toInt()),
      );

      _rewardedAd = null;

      // Load next ad.
      load();
    }
  }
}
