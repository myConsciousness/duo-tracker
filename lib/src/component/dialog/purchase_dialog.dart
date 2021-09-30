// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

late AwesomeDialog _dialog;

Future<T?> showPurchaseDialog<T>({
  required BuildContext context,
  required int currentPoint,
  required int price,
  required String productName,
  required int timeLimitInEpoch,
  required Function onPressedOk,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.QUESTION,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Container(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Center(
                  child: Text(
                    'Purchase Confirmation',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Center(
                  child: Text(
                      'Do you want to spend your points to purchase this item?'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 0,
                  child: Column(
                    children: const [
                      ListTile(
                        title: Text('Disable Full Screen Ads'),
                        subtitle: Text('Valid until 2021/12/01 13:00'),
                      ),
                      CommonDivider(),
                      Text(
                        '* The expiration date is valid since the time of confirm, so the expiration dates shown above are for reference only.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Confirm',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () {
                    onPressedOk.call();
                    _dialog.dismiss();
                  },
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Cancel',
                  color: Theme.of(context).colorScheme.error,
                  pressEvent: () {
                    _dialog.dismiss();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await _dialog.show();
}
