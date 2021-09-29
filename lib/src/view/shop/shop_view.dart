// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/reawarde_ad_utils.dart';
import 'package:duo_tracker/src/component/dialog/charge_point_dialog.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_type.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

  /// The point
  int _point = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<void> _asyncInitState() async {
    _point = await CommonSharedPreferencesKey.rewardPoint.getInt(
      defaultValue: 0,
    );

    super.setState(() {});
  }

  Widget _buildWalletCard() => Padding(
        padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(FontAwesomeIcons.wallet),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        'You have ${_numericTextFormat.format(_point)} points'),
                    IconButton(
                      tooltip: 'Update Point',
                      icon: const Icon(Icons.sync),
                      onPressed: () async {
                        final currentRewardPoint =
                            await CommonSharedPreferencesKey.rewardPoint
                                .getInt(defaultValue: 0);

                        super.setState(() {
                          _point = currentRewardPoint;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: AnimatedButton(
                  isFixedHeight: false,
                  text: 'Charge +2 Points',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    await RewardedAdUtils.showRewarededAd(
                      context: context,
                      sharedPreferencesKey:
                          RewardedAdSharedPreferencesKey.rewardImmediately,
                      showForce: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildDisableAdProductsCard({
    required String title,
    required String subtitle,
    required DisableAdProductType productType,
  }) =>
      Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(FontAwesomeIcons.shoppingBasket),
                  title: Text(title),
                  subtitle: Text(
                    subtitle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDisableAdProductCard(
                      title: '30 minutes',
                      price: 5 * productType.priceWeight,
                      productType: productType,
                      disableAdType: DisableAdType.m30,
                    ),
                    _buildDisableAdProductCard(
                      title: '1 hour',
                      price: 15 * productType.priceWeight,
                      productType: productType,
                      disableAdType: DisableAdType.h1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDisableAdProductCard(
                      title: '3 hours',
                      price: 30 * productType.priceWeight,
                      productType: productType,
                      disableAdType: DisableAdType.h3,
                    ),
                    _buildDisableAdProductCard(
                      title: '6 hours',
                      price: 50 * productType.priceWeight,
                      productType: productType,
                      disableAdType: DisableAdType.h6,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDisableAdProductCard(
                      title: '12 hours',
                      price: 80 * productType.priceWeight,
                      productType: productType,
                      disableAdType: DisableAdType.h12,
                    ),
                    _buildDisableAdProductCard(
                      title: '24 hours',
                      price: 100 * productType.priceWeight,
                      productType: productType,
                      disableAdType: DisableAdType.h24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildDisableAdProductCard({
    required String title,
    required int price,
    required DisableAdProductType productType,
    required DisableAdType disableAdType,
  }) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: AnimatedButton(
                    isFixedHeight: false,
                    text: '$price Points',
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    pressEvent: () async {
                      final currentPoint =
                          await CommonSharedPreferencesKey.rewardPoint.getInt();

                      if (currentPoint < price) {
                        await showChargePointDialog(context: context);
                        return;
                      }

                      if (await _alreadyAdDisabled(productType: productType)) {
                        // If the disable setting is enabled, do not let the user make a new purchase.
                        await showErrorDialog(
                          context: context,
                          title: 'Purchase Error',
                          content:
                              'Disabling ad is already enabled. Please wait for the time limit of the last product type you purchased to expire.',
                        );
                        return;
                      }

                      // TODO: 確認ダイアログの追加
                      await CommonSharedPreferencesKey.rewardPoint
                          .setInt(currentPoint - price);

                      await _disableAds(
                        productType: productType,
                        disableAdType: disableAdType,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _disableAds({
    required DisableAdProductType productType,
    required DisableAdType disableAdType,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        await CommonSharedPreferencesKey.disableFullScreenType
            .setInt(disableAdType.code);
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(
          DateTime.now().millisecondsSinceEpoch,
        );

        break;
      case DisableAdProductType.disableBannerAd:
        await CommonSharedPreferencesKey.disableBannerType
            .setInt(disableAdType.code);
        await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(
          DateTime.now().millisecondsSinceEpoch,
        );

        break;
      case DisableAdProductType.all:
        // Enables all
        await CommonSharedPreferencesKey.disableFullScreenType
            .setInt(disableAdType.code);
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(
          DateTime.now().millisecondsSinceEpoch,
        );

        await CommonSharedPreferencesKey.disableBannerType
            .setInt(disableAdType.code);
        await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(
          DateTime.now().millisecondsSinceEpoch,
        );

        break;
    }
  }

  Future<bool> _alreadyAdDisabled({
    required DisableAdProductType productType,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        return await CommonSharedPreferencesKey.disableFullScreenType
                .getInt() !=
            -1;
      case DisableAdProductType.disableBannerAd:
        return await CommonSharedPreferencesKey.disableBannerType.getInt() !=
            -1;
      case DisableAdProductType.all:
        return await CommonSharedPreferencesKey.disableFullScreenType
                    .getInt() !=
                -1 &&
            await CommonSharedPreferencesKey.disableBannerType.getInt() != -1;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildWalletCard(),
                  _buildDisableAdProductsCard(
                    title: 'Disable Full Screen Ads',
                    subtitle:
                        'You can disable full-screen ads for a certain period of time. Ads for recharging points in this store will not be disabled.',
                    productType: DisableAdProductType.disbaleFullScreenAd,
                  ),
                  _buildDisableAdProductsCard(
                    title: 'Disable Banner Ads',
                    subtitle:
                        'You can disable banner ads for a certain period of time.',
                    productType: DisableAdProductType.disableBannerAd,
                  ),
                  _buildDisableAdProductsCard(
                    title: 'Disable All Ads',
                    subtitle:
                        'You can disable all ads for a certain period of time. Ads for recharging points in this store will not be disabled.',
                    productType: DisableAdProductType.all,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
