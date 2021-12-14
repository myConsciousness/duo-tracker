// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/admob/reawarded_ad_utils.dart';
import 'package:duo_tracker/src/component/common_dialog_content.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/repository/preference/rewarded_ad_shared_preferences.dart';

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
                const CommonDialogTitle(title: 'Need to charge point!'),
                const SizedBox(
                  height: 20,
                ),
                const CommonDialogContent(
                  content:
                      'You have not enough points to get the benefit. Please watch ads and recharge your points.',
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonDialogSubmitButton(
                  title: 'Charge',
                  pressEvent: () async {
                    await RewardedAdUtils.showRewarededAd(
                      context: context,
                      key: RewardedAdSharedPreferencesKey.rewardImmediately,
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
