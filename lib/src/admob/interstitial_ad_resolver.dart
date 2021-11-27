// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';

class InterstitialAdResolver {
  /// The internal constructor.
  InterstitialAdResolver._internal();

  /// Returns the singleton instance of [InterstitialAdResolver].
  factory InterstitialAdResolver.getInstance() => _singletonInstance;

  /// The singleton instance of this [InterstitialAdResolver].
  static final _singletonInstance = InterstitialAdResolver._internal();

  /// The count load attempt
  int _countLoadAttempt = 0;

  /// The interstitial ad
  InterstitialAd? _interstitialAd;

  /// Returns [true] if interstitial ad is already loaded, otherwise [false].
  bool get adLoaded => _interstitialAd != null;

  Future<void> loadInterstitialAd() async => await InterstitialAd.load(
        adUnitId: DuoTrackerAdmobUnitIds.getInstance().releaseInterstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (final InterstitialAd interstitialAd) {
            _interstitialAd = interstitialAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final LoadAdError loadAdError) async {
            _interstitialAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 5) {
              await loadInterstitialAd();
            }
          },
        ),
      );

  Future<void> showInterstitialAd({
    required Function(int reward) onAdShowed,
  }) async {
    if (_interstitialAd == null) {
      await loadInterstitialAd();
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (final interstitialAd) {},
      onAdDismissedFullScreenContent: (final interstitialAd) async {
        await interstitialAd.dispose();
        onAdShowed.call(3);
      },
      onAdFailedToShowFullScreenContent:
          (final interstitialAd, final adError) async {
        await interstitialAd.dispose();
        await loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
    _interstitialAd = null;

    /// Reload next ad
    await loadInterstitialAd();
  }
}
