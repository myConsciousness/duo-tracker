// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:duo_tracker/src/admob/reawarded_ad_utils.dart';
import 'package:duo_tracker/src/component/common_app_bar_title.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/common_product_basket_card.dart';
import 'package:duo_tracker/src/component/common_product_basket_content.dart';
import 'package:duo_tracker/src/component/common_product_list.dart';
import 'package:duo_tracker/src/component/dialog/charge_point_dialog.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/purchase_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/success_snack_bar.dart';
import 'package:duo_tracker/src/const/operand.dart';
import 'package:duo_tracker/src/context/disable_ad_context.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/utils/disable_all_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:duo_tracker/src/utils/wallet_balance.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';
import 'package:duo_tracker/src/view/shop/purchase_history_tab_view.dart';

class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

  /// The wallet balance
  final _walletBalance = WalletBalance.getInstance();

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  Future<void> _asyncInitState() async {
    if (await DisableFullScreenAdSupport.isEnabled() &&
        await DisableFullScreenAdSupport.isExpired()) {
      await DisableFullScreenAdSupport.clearPurchasedProduct();
    }

    if (await DisableBannerAdSupport.isEnabled() &&
        await DisableBannerAdSupport.isExpired()) {
      await DisableBannerAdSupport.clearPurchasedProduct();
    }

    super.setState(() {});
  }

  Widget _buildWalletCard() => Padding(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(
                  child: Text(
                    'You have ${_numericTextFormat.format(_walletBalance.point)} points!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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

  Widget _buildFreeDisableAdProductCard({
    required String title,
    required String subtitle,
  }) =>
      CommonProductBasketCard(
        content: CommonProductBasketContent(
          title: title,
          subtitle: subtitle,
          body: CommonProductList(
            productType: DisableAdProductType.all,
            disableAdPatterns: const [DisableAdPattern.m5],
            onPressedButton: (price, productType, disableAdPattern) async =>
                await _onPressedPurchase(
              price: price,
              productType: productType,
              disableAdPattern: disableAdPattern,
            ),
          ),
        ),
      );

  Widget _buildDisableAdProductsCard({
    required String title,
    required String subtitle,
    required DisableAdProductType productType,
  }) =>
      CommonProductBasketCard(
        content: CommonProductBasketContent(
          title: title,
          subtitle: subtitle,
          body: CommonProductList(
            productType: productType,
            disableAdPatterns: DisableAdPatternExt.paidPatterns,
            onPressedButton: (price, productType, disableAdPattern) async =>
                await _onPressedPurchase(
              price: price,
              productType: productType,
              disableAdPattern: disableAdPattern,
            ),
          ),
        ),
      );

  Future<void> _onPressedPurchase({
    required int price,
    required DisableAdProductType productType,
    required DisableAdPattern disableAdPattern,
  }) async {
    if (await _alreadyAdDisabled(productType: productType)) {
      // If the disable setting is enabled, do not let the user make a new purchase.
      await showErrorDialog(
        context: context,
        title: 'Purchase Error',
        content:
            'Disabling ads is already enabled. Please wait for the time limit of the last product you purchased to expire.',
      );
      return;
    }

    final currentPoint = await CommonSharedPreferencesKey.rewardPoint.getInt();

    if (disableAdPattern != DisableAdPattern.m5 && currentPoint < price) {
      await showChargePointDialog(
        context: context,
        onRewarded: (int amount) async => await _refreshPointOnRewarded(
          rewardedAmount: amount,
        ),
      );
      return;
    }

    if (disableAdPattern == DisableAdPattern.m5) {
      await RewardedAdUtils.showRewarededAd(
        context: context,
        sharedPreferencesKey: RewardedAdSharedPreferencesKey.rewardImmediately,
        onRewarded: (_) async {
          await DisableAdContext.from(
            disableAdProductType: productType,
            disableAdPattern: disableAdPattern,
          ).execute();

          super.setState(() {});
        },
        showForce: true,
      );
    } else {
      await showPurchaseDialog(
        context: context,
        price: price,
        productName: productType.name,
        validPeriodInMinutes: disableAdPattern.limit,
        onPressedOk: () async {
          await _walletBalance.refresh(
            operand: Operand.minus,
            change: price,
          );

          await DisableAdContext.from(
            disableAdProductType: productType,
            disableAdPattern: disableAdPattern,
          ).execute();

          super.setState(() {});
        },
      );
    }
  }

  Future<void> _refreshPointOnRewarded({
    required int rewardedAmount,
  }) async {
    await _walletBalance.refresh(
      operand: Operand.plus,
      change: rewardedAmount,
    );

    SuccessSnackBar.from(context: context).show(
      content:
          'Thank you for looking at ad! Your wallet has been credited with 2 points!',
    );

    super.setState(() {});
  }

  Future<bool> _alreadyAdDisabled({
    required DisableAdProductType productType,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        return await DisableFullScreenAdSupport.isEnabled();
      case DisableAdProductType.disableBannerAd:
        return await DisableBannerAdSupport.isEnabled();
      case DisableAdProductType.all:
        return await DisableAllAdSupport.isEnabled();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: const CommonAppBarTitle(title: 'Shop'),
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
                    _buildFreeDisableAdProductCard(
                      title: 'Disable All Ads (Free)',
                      subtitle:
                          'You can disable all ads for 5 minutes. This product is reflected instantly without consuming any points once you watch the ad. This product does not create a purchase history.',
                    ),
                    _buildDisableAdProductsCard(
                      title: 'Disable Full Screen Ads',
                      subtitle:
                          'You can disable full-screen ads for a certain period of time.',
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
                          'You can disable all ads for a certain period of time.',
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
