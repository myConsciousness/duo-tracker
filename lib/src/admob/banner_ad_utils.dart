// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/duo_tracker_admob_unit_ids.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
    bool header = false,
  }) async {
    if (!F.isFreeBuild) {
      return false;
    }

    final disableBannerPatternCode =
        await CommonSharedPreferencesKey.disableBannerPattern.getInt();

    if (disableBannerPatternCode != -1) {
      final disableBannerPattern =
          DisableAdPatternExt.toEnum(code: disableBannerPatternCode);
      final purchasedDatetime = DateTime.fromMillisecondsSinceEpoch(
        await CommonSharedPreferencesKey.datetimeDisabledBanner.getInt(),
      );

      if (DateTime.now().difference(purchasedDatetime).inMinutes.abs() >
          disableBannerPattern.timeLimit) {
        await CommonSharedPreferencesKey.disableBannerPattern.setInt(-1);
        await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(-1);
      } else {
        return false;
      }
    }

    if (index > -1 && interval > -1) {
      if (header) {
        return index % interval == 0;
      } else {
        return index != 0 && index % interval == 0;
      }
    }

    return true;
  }
}
