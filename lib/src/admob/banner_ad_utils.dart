// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc_flutter/src/admob/duovoc_admob_unit_ids.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdUtils {
  static Widget createBannerAdWidget(BannerAd bannerAd) => Container(
        height: 50,
        child: AdWidget(ad: bannerAd),
      );

  static BannerAd loadBannerAd() => BannerAd(
        size: AdSize.banner,
        adUnitId: DuovocAdmobUnitIds.getInstance().banner,
        listener: BannerAdListener(),
        request: AdRequest(),
      )..load();
}
