// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/admob/duovoc_admob_unit_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  void loadInterstitialAd() async => await InterstitialAd.load(
        adUnitId: DuovocAdmobUnitIds.getInstance().releaseInterstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (final InterstitialAd interstitialAd) {
            _interstitialAd = interstitialAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final LoadAdError loadAdError) {
            _interstitialAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 2) {
              loadInterstitialAd();
            }
          },
        ),
      );

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (final InterstitialAd interstitialAd) {},
      onAdDismissedFullScreenContent: (final InterstitialAd interstitialAd) {
        interstitialAd.dispose();
      },
      onAdFailedToShowFullScreenContent:
          (final InterstitialAd interstitialAd, final AdError adError) {
        interstitialAd.dispose();
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
