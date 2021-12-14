// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

// Project imports:
import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';

class InterstitialAd {
  /// The internal constructor.
  InterstitialAd._internal();

  /// Returns the singleton instance of [InterstitialAd].
  static InterstitialAd get instance => _singletonInstance;

  /// The singleton instance of this [InterstitialAd].
  static final _singletonInstance = InterstitialAd._internal();

  /// The count load attempt
  int _countLoadAttempt = 0;

  /// The interstitial ad
  admob.InterstitialAd? _interstitialAd;

  /// Returns true if interstitial ad is already loaded, otherwise false.
  bool get isLoaded => _interstitialAd != null;

  Future<void> _load() async => await admob.InterstitialAd.load(
        adUnitId: DuoTrackerAdmobUnitIds.getInstance().releaseInterstitial,
        request: const admob.AdRequest(),
        adLoadCallback: admob.InterstitialAdLoadCallback(
          onAdLoaded: (final interstitialAd) {
            _interstitialAd = interstitialAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final loadAdError) async {
            _interstitialAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 5) {
              await _load();
            }
          },
        ),
      );

  Future<void> show({
    required Function(int reward) onAdShowed,
  }) async {
    if (!isLoaded) {
      await _load();
    }

    if (isLoaded) {
      _interstitialAd!.fullScreenContentCallback =
          admob.FullScreenContentCallback(
        onAdShowedFullScreenContent: (final interstitialAd) {},
        onAdDismissedFullScreenContent: (final interstitialAd) async {
          await interstitialAd.dispose();
          onAdShowed.call(3);
        },
        onAdFailedToShowFullScreenContent:
            (final interstitialAd, final adError) async {
          await interstitialAd.dispose();
        },
      );

      await _interstitialAd!.show();
      _interstitialAd = null;
    }
  }
}
