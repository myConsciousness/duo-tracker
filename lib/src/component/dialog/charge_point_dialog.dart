// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/reawarde_ad_utils.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';
import 'package:flutter/material.dart';

AwesomeDialog? _dialog;

Future<T?> showChargePointDialog<T>({
  required BuildContext context,
  required Function(int amount) onRewarded,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: DialogType.INFO,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Center(
                  child: Text(
                    'Need to charge point!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'You have not enough points to get the benefit.',
                  ),
                ),
                const Center(
                  child: Text(
                    'Please watch ads and recharge your points.',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Charge',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    await RewardedAdUtils.showRewarededAd(
                      context: context,
                      sharedPreferencesKey:
                          RewardedAdSharedPreferencesKey.rewardImmediately,
                      onRewarded: onRewarded,
                      showForce: true,
                    );

                    _dialog!.dismiss();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await _dialog!.show();
}
