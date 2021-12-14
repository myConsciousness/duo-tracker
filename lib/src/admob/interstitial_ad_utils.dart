// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/admob/interstitial_ad.dart';
import 'package:duo_tracker/src/component/dialog/recommended_action_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/const/operand.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:duo_tracker/src/utils/wallet_balance.dart';

class InterstitialAdUtils {
  static Future<void> showInterstitialAd({
    BuildContext? context,
    required InterstitialAdSharedPreferencesKey key,
  }) async {
    if (F.isPaidBuild) {
      return;
    }

    if (await _adDisabled(key: key)) {
      return;
    }

    int count = await key.getInt();
    count++;

    if (count >= key.limit) {
      final interstitialAd = InterstitialAd.instance;

      await interstitialAd.show(
        onAdShowed: (reward) async {
          if (context != null) {
            await _refreshPoint(
              context: context,
              reward: reward,
            );

            await _showRecommendationIfNecessary(
              context: context,
            );

            await key.setInt(0);
          }
        },
      );
    } else {
      await key.setInt(count);
    }
  }

  static Future<bool> _adDisabled({
    required InterstitialAdSharedPreferencesKey key,
  }) async {
    if (!await DisableFullScreenAdSupport.isEnabled()) {
      return false;
    }

    if (await DisableFullScreenAdSupport.isExpired()) {
      await DisableFullScreenAdSupport.clearPurchasedProduct();
      return false;
    }

    int count = await key.getInt();

    count++;
    await key.setInt(count);

    return true;
  }

  static Future<void> _refreshPoint({
    required BuildContext context,
    required int reward,
  }) async {
    await WalletBalance.getInstance().refresh(
      operand: Operand.plus,
      change: reward,
    );

    InfoSnackbar.from(context: context).show(
      content:
          'Thank you for looking at ad! $reward points were given as a reward!',
    );
  }

  static Future<void> _showRecommendationIfNecessary({
    required BuildContext context,
  }) async {
    int count =
        await CommonSharedPreferencesKey.countShowedInterstitialAd.getInt();

    if (_canShowRecommendation(count: count)) {
      await showRecommendedActionDialog(context: context);
      await CommonSharedPreferencesKey.countShowedInterstitialAd.setInt(0);
    } else {
      count++;
      await CommonSharedPreferencesKey.countShowedInterstitialAd.setInt(count);
    }
  }

  static bool _canShowRecommendation({required int count}) =>
      count == -1 || count > 1;
}
