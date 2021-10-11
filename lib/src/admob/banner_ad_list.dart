// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdList {
  /// Returns the new instance of [BannerAdList].
  BannerAdList.newInstance();

  /// The banner ads
  final _bannerAds = <BannerAd>[];

  BannerAd loadNewBanner() {
    final bannerAd = BannerAdUtils.loadBannerAd();
    _bannerAds.add(bannerAd);
    return bannerAd;
  }

  void dispose() {
    for (final bannerAd in _bannerAds) {
      bannerAd.dispose();
    }
  }
}
