// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/reawarde_ad_utils.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/dialog/charge_point_dialog.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/purchase_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_type.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';
import 'package:duo_tracker/src/view/shop/purchase_history_tab_view.dart';
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
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(FontAwesomeIcons.wallet),
                title: Text(
                    'You have ${_numericTextFormat.format(_point)} points'),
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
                      onRewarded: (int amount) async =>
                          await _refreshPointOnRewarded(
                        rewardedAmount: amount,
                      ),
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
                      disableAdPattern: DisableAdPattern.m30,
                    ),
                    _buildDisableAdProductCard(
                      title: '1 hour',
                      price: 15 * productType.priceWeight,
                      productType: productType,
                      disableAdPattern: DisableAdPattern.h1,
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
                      disableAdPattern: DisableAdPattern.h3,
                    ),
                    _buildDisableAdProductCard(
                      title: '6 hours',
                      price: 50 * productType.priceWeight,
                      productType: productType,
                      disableAdPattern: DisableAdPattern.h6,
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
                      disableAdPattern: DisableAdPattern.h12,
                    ),
                    _buildDisableAdProductCard(
                      title: '24 hours',
                      price: 100 * productType.priceWeight,
                      productType: productType,
                      disableAdPattern: DisableAdPattern.h24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Future<String> _buildPurchaseButtonTitle({
    required DisableAdProductType productType,
    required DisableAdPattern disableAdType,
    required String defaultTitle,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        final disableFullScreenTypeCode =
            await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();

        if (disableFullScreenTypeCode == -1) {
          return defaultTitle;
        }

        final purchasedDisableAdType =
            DisableAdPatternExt.toEnum(code: disableFullScreenTypeCode);

        if (purchasedDisableAdType == disableAdType) {
          return 'Enabled';
        }

        return defaultTitle;
      case DisableAdProductType.disableBannerAd:
        final disableBannerTypeCode =
            await CommonSharedPreferencesKey.disableBannerPattern.getInt();

        if (disableBannerTypeCode == -1) {
          return defaultTitle;
        }

        final purchasedDisableAdType =
            DisableAdPatternExt.toEnum(code: disableBannerTypeCode);

        if (purchasedDisableAdType == disableAdType) {
          return 'Enabled';
        }

        return defaultTitle;
      case DisableAdProductType.all:
        final disableFullScreenTypeCode =
            await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();
        final disableBannerTypeCode =
            await CommonSharedPreferencesKey.disableBannerPattern.getInt();

        if (disableFullScreenTypeCode == -1 && disableBannerTypeCode == -1) {
          return defaultTitle;
        }

        if (await _disabledAll()) {
          final purchasedDisableAdType =
              DisableAdPatternExt.toEnum(code: disableFullScreenTypeCode);

          if (purchasedDisableAdType == disableAdType) {
            return 'Enabled';
          }

          return defaultTitle;
        } else {
          return defaultTitle;
        }
    }
  }

  Future<bool> _disabledAll() async {
    final disableFullScreenTypeCode =
        await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();
    final disableBannerTypeCode =
        await CommonSharedPreferencesKey.disableBannerPattern.getInt();

    if (disableFullScreenTypeCode == -1 || disableBannerTypeCode == -1) {
      return false;
    }

    final datetimeDisabledFullScreen =
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.getInt();
    final datetimeDisabledBanner =
        await CommonSharedPreferencesKey.datetimeDisabledBanner.getInt();

    if (datetimeDisabledFullScreen != datetimeDisabledBanner) {
      return false;
    }

    return true;
  }

  Widget _buildDisableAdProductCard({
    required String title,
    required int price,
    required DisableAdProductType productType,
    required DisableAdPattern disableAdPattern,
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
                  child: FutureBuilder(
                    future: _buildPurchaseButtonTitle(
                      productType: productType,
                      disableAdType: disableAdPattern,
                      defaultTitle: '$price Points',
                    ),
                    builder:
                        (BuildContext context, AsyncSnapshot titleSnapshot) {
                      if (!titleSnapshot.hasData) {
                        return const Loading();
                      }

                      return FutureBuilder(
                        future: _getDisableAdPurchaseButtonColor(
                          productType: productType,
                          disableAdPattern: disableAdPattern,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot buttonColorSnapshot) {
                          if (!buttonColorSnapshot.hasData) {
                            return const Loading();
                          }

                          return _buildDisableAdPurchaseButton(
                            title: titleSnapshot.data,
                            color: buttonColorSnapshot.data,
                            price: price,
                            product: productType,
                            disableAdPattern: disableAdPattern,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildDisableAdPurchaseButton({
    required String title,
    required Color color,
    required int price,
    required DisableAdProductType product,
    required DisableAdPattern disableAdPattern,
  }) =>
      AnimatedButton(
        isFixedHeight: false,
        text: title,
        color: color,
        pressEvent: () async {
          if (await _alreadyAdDisabled(productType: product)) {
            // If the disable setting is enabled, do not let the user make a new purchase.
            await showErrorDialog(
              context: context,
              title: 'Purchase Error',
              content:
                  'Disabling ads is already enabled. Please wait for the time limit of the last product you purchased to expire.',
            );
            return;
          }

          final currentPoint =
              await CommonSharedPreferencesKey.rewardPoint.getInt();

          if (currentPoint < price) {
            await showChargePointDialog(
              context: context,
              onRewarded: (int amount) async => await _refreshPointOnRewarded(
                rewardedAmount: amount,
              ),
            );

            return;
          }

          await showPurchaseDialog(
            context: context,
            price: price,
            productName: product.name,
            validPeriodInMinutes: disableAdPattern.timeLimit,
            onPressedOk: () async {
              final newPoint = currentPoint - price;
              await CommonSharedPreferencesKey.rewardPoint.setInt(newPoint);

              await _disableAds(
                productType: product,
                disableAdPattern: disableAdPattern,
              );

              super.setState(() {
                _point = newPoint;
              });
            },
          );
        },
      );

  Future<void> _refreshPointOnRewarded({
    required int rewardedAmount,
  }) async {
    final currentPoint = await CommonSharedPreferencesKey.rewardPoint.getInt(
      defaultValue: 0,
    );

    final newPoint = currentPoint + rewardedAmount;

    await CommonSharedPreferencesKey.rewardPoint.setInt(
      newPoint,
    );

    super.setState(() {
      _point = newPoint;
    });
  }

  Future<Color> _getDisableAdPurchaseButtonColor({
    required DisableAdProductType productType,
    required DisableAdPattern disableAdPattern,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        final disableAdTypeCode =
            await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();

        if (disableAdTypeCode == -1) {
          // Available color
          return Theme.of(context).colorScheme.secondaryVariant;
        }

        if (disableAdTypeCode == disableAdPattern.code) {
          // Enabled color
          return Theme.of(context).colorScheme.secondaryVariant;
        }

        return Colors.grey;
      case DisableAdProductType.disableBannerAd:
        final disableAdTypeCode =
            await CommonSharedPreferencesKey.disableBannerPattern.getInt();

        if (disableAdTypeCode == -1) {
          // Available color
          return Theme.of(context).colorScheme.secondaryVariant;
        }

        if (disableAdTypeCode == disableAdPattern.code) {
          // Enabled color
          return Theme.of(context).colorScheme.secondaryVariant;
        }

        return Colors.grey;
      case DisableAdProductType.all:
        final disableFullScreenAdTypeCode =
            await CommonSharedPreferencesKey.disableFullScreenPattern.getInt();
        final disableBannerAdTypeCode =
            await CommonSharedPreferencesKey.disableBannerPattern.getInt();

        if (disableFullScreenAdTypeCode == -1 &&
            disableBannerAdTypeCode == -1) {
          // Available color
          return Theme.of(context).colorScheme.secondaryVariant;
        }

        final datetimeDisabledFullScreen = await CommonSharedPreferencesKey
            .datetimeDisabledFullScreen
            .getInt();
        final datetimeDisabledBanner =
            await CommonSharedPreferencesKey.datetimeDisabledBanner.getInt();

        if (datetimeDisabledFullScreen == datetimeDisabledBanner) {
          // Enabled color
          return Theme.of(context).colorScheme.secondaryVariant;
        }

        return Colors.grey;
    }
  }

  Future<void> _disableAds({
    required DisableAdProductType productType,
    required DisableAdPattern disableAdPattern,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        await CommonSharedPreferencesKey.disableFullScreenPattern
            .setInt(disableAdPattern.code);
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(
          DateTime.now().millisecondsSinceEpoch,
        );

        break;
      case DisableAdProductType.disableBannerAd:
        await CommonSharedPreferencesKey.disableBannerPattern
            .setInt(disableAdPattern.code);
        await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(
          DateTime.now().millisecondsSinceEpoch,
        );

        break;
      case DisableAdProductType.all:
        // Enables all at the same time
        final now = DateTime.now().millisecondsSinceEpoch;

        await CommonSharedPreferencesKey.disableFullScreenPattern
            .setInt(disableAdPattern.code);
        await CommonSharedPreferencesKey.datetimeDisabledFullScreen.setInt(now);

        await CommonSharedPreferencesKey.disableBannerPattern
            .setInt(disableAdPattern.code);
        await CommonSharedPreferencesKey.datetimeDisabledBanner.setInt(now);

        break;
    }
  }

  Future<bool> _alreadyAdDisabled({
    required DisableAdProductType productType,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        return await CommonSharedPreferencesKey.disableFullScreenPattern
                .getInt() !=
            -1;
      case DisableAdProductType.disableBannerAd:
        return await CommonSharedPreferencesKey.disableBannerPattern.getInt() !=
            -1;
      case DisableAdProductType.all:
        return await CommonSharedPreferencesKey.disableFullScreenPattern
                    .getInt() !=
                -1 ||
            await CommonSharedPreferencesKey.disableBannerPattern.getInt() !=
                -1;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: const Center(
            child: Text(
              'Shop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchaseHistoryTabView(),
                  ),
                );
              },
            ),
          ],
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
        ),
      );
}
