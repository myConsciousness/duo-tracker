// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/reawarde_ad_utils.dart';
import 'package:duo_tracker/src/component/dialog/charge_point_dialog.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:duo_tracker/src/view/shop/disable_full_screen_type.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
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
                  _buildDisableAdProductCard(),
                ],
              ),
            ),
          ),
        ),
      );

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
                            RewardedAdSharedPreferencesKey.rewardImmediately);
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildDisableAdProductCard() => Padding(
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
                const ListTile(
                  leading: Icon(FontAwesomeIcons.shoppingBasket),
                  title: Text('Disable full-screen ads'),
                  subtitle: Text(
                      'You can disable full-screen ads for a certain period of time. Ads for recharging points in this store will not be disabled.'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProductCard(
                      title: '30 minutes',
                      price: 5,
                      disableFullScreenType: DisableFullScreenType.m30,
                    ),
                    _buildProductCard(
                      title: '1 hour',
                      price: 20,
                      disableFullScreenType: DisableFullScreenType.h1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProductCard(
                      title: '3 hours',
                      price: 40,
                      disableFullScreenType: DisableFullScreenType.h3,
                    ),
                    _buildProductCard(
                      title: '6 hours',
                      price: 70,
                      disableFullScreenType: DisableFullScreenType.h6,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProductCard(
                      title: '12 hours',
                      price: 120,
                      disableFullScreenType: DisableFullScreenType.h12,
                    ),
                    _buildProductCard(
                      title: '24 hours',
                      price: 200,
                      disableFullScreenType: DisableFullScreenType.h24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildProductCard({
    required String title,
    required int price,
    required DisableFullScreenType disableFullScreenType,
  }) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            elevation: 2,
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

                      final productType = await CommonSharedPreferencesKey
                          .disableFullScreenType
                          .getInt();

                      if (productType != -1) {
                        // If the disable setting is enabled, do not let the user make a new purchase.
                        await showErrorDialog(
                          context: context,
                          title: 'Purchase Error',
                          content:
                              'Disabling full-screen ads is already enabled. Please wait for the time limit of the last product type you purchased to expire.',
                        );
                        return;
                      }

                      await CommonSharedPreferencesKey.rewardPoint
                          .setInt(currentPoint - price);

                      await CommonSharedPreferencesKey.disableFullScreenType
                          .setInt(disableFullScreenType.code);
                      await CommonSharedPreferencesKey
                          .datetimeDisabledFullScreen
                          .setInt(
                        DateTime.now().millisecondsSinceEpoch,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
