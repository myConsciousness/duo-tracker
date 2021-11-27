// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';

class BannerAdUtils {
  static Widget createBannerAdWidget(BannerAd bannerAd) => SizedBox(
        height: 50,
        child: AdWidget(ad: bannerAd),
      );

  static BannerAd loadBannerAd() => BannerAd(
        size: AdSize.banner,
        adUnitId: DuoTrackerAdmobUnitIds.getInstance().banner,
        listener: const BannerAdListener(),
        request: const AdRequest(),
      )..load();

  static Future<bool> canShow({
    int index = -1,
    int interval = -1,
  }) async {
    if (F.isPaidBuild) {
      return false;
    }

    if (await DisableBannerAdSupport.isEnabled()) {
      if (!await DisableBannerAdSupport.isExpired()) {
        return false;
      }

      // When purchased product is expired.
      await DisableBannerAdSupport.clearPurchasedProduct();
    }

    if (index < 0 && interval < 0) {
      // When there is no specific condition of index and interval
      return true;
    }

    return index != 0 && index % interval == 0;
  }
}
