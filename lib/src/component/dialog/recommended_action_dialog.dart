// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/reawarded_ad_utils.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/common_product_detail_card.dart';
import 'package:duo_tracker/src/component/common_transparent_text_button.dart';
import 'package:duo_tracker/src/component/text_with_horizontal_divider.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/utils/disable_all_ad_support.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';
import 'package:duo_tracker/src/view/shop/shop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:url_launcher/url_launcher.dart';

/// The dialog
late AwesomeDialog _dialog;

Future<T?> showRecommendedActionDialog<T>({
  required BuildContext context,
}) async {
  _dialog = _buildDialog(
    context: context,
  );

  await _dialog.show();
}

AwesomeDialog _buildDialog({
  required BuildContext context,
}) =>
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: _buildDialogBody(),
    );

Widget _buildDialogBody() => StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const CommonDialogTitle(title: 'Recommended Action!'),
                const SizedBox(
                  height: 30,
                ),
                CommonProductDetailCard(
                  productName: DisableAdProductType.all.name,
                  validPeriodInMinutes: DisableAdPattern.m5.limit,
                ),
                CommonDialogSubmitButton(
                  title: 'Disable All Ads (Free)',
                  pressEvent: () async {
                    await RewardedAdUtils.showRewarededAd(
                      context: context,
                      sharedPreferencesKey:
                          RewardedAdSharedPreferencesKey.rewardImmediately,
                      onRewarded: (_) async {
                        await DisableAllAdSupport.disable(
                          disableAdPattern: DisableAdPattern.m5,
                        );

                        await _dialog.dismiss();
                      },
                      showForce: true,
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextWithHorizontalDivider(
                  value: 'OR',
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTransparentTextButton(
                  title: 'Check Other Items',
                  onPressed: () async => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShopView(),
                    ),
                  ),
                ),
                CommonTransparentTextButton(
                  title: 'Buy NoAds Version',
                  onPressed: () async => await launch(
                      'https://play.google.com/store/apps/details?id=${FlavorConfig.instance.variables['paidPackageId']}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
