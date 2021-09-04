// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/admob/duovoc_admob_unit_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdResolver {
  /// The singleton instance of this [InterstitialAdResolver].
  static final InterstitialAdResolver _singletonInstance =
      InterstitialAdResolver._internal();

  /// The internal constructor.
  InterstitialAdResolver._internal();

  /// Returns the singleton instance of [InterstitialAdResolver].
  factory InterstitialAdResolver.getInstance() => _singletonInstance;

  /// The interstitial ad
  InterstitialAd? _interstitialAd;

  /// The count load attempt
  int _countLoadAttempt = 0;

  void loadInterstitialAd() async => await InterstitialAd.load(
        adUnitId: DuovocAdmobUnitIds.getInstance().releaseInterstitial,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (final InterstitialAd interstitialAd) {
            this._interstitialAd = interstitialAd;
            this._countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final LoadAdError loadAdError) {
            this._interstitialAd = null;
            this._countLoadAttempt++;

            if (this._countLoadAttempt <= 2) {
              this.loadInterstitialAd();
            }
          },
        ),
      );

  void showInterstitialAd() {
    if (this._interstitialAd == null) {
      return;
    }

    this._interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (final InterstitialAd interstitialAd) {},
      onAdDismissedFullScreenContent: (final InterstitialAd interstitialAd) {
        interstitialAd.dispose();
      },
      onAdFailedToShowFullScreenContent:
          (final InterstitialAd interstitialAd, final AdError adError) {
        interstitialAd.dispose();
        this.loadInterstitialAd();
      },
    );

    this._interstitialAd!.show();
    this._interstitialAd = null;
  }
}
