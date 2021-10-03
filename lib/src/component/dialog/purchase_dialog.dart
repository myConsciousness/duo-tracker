// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/repository/model/purchase_history_model.dart';
import 'package:duo_tracker/src/repository/service/purchase_history_service.dart';
import 'package:duo_tracker/src/view/shop/price_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

late AwesomeDialog _dialog;
final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

/// The purchase history service
final _purchaseHistoryService = PurchaseHistoryService.getInstance();

Future<T?> showPurchaseDialog<T>({
  required BuildContext context,
  required String productName,
  required int price,
  required int validPeriodInMinutes,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            productName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          subtitle: Text(
                            'Expiration: ${_datetimeFormat.format(DateTime.now().add(Duration(minutes: validPeriodInMinutes)))}',
                          ),
                        ),
                        const CommonDivider(),
                        const Center(
                          child: Text(
                            '* The expiration datetime is valid since its confirmed.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Confirm',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    await onPressedOk.call();

                    _purchaseHistoryService.insert(
                      PurchaseHistory.from(
                        productName: productName,
                        price: price,
                        priceType: PriceType.duoTrackerPoint.code,
                        validPeriodInMinutes: validPeriodInMinutes,
                        purchasedAt: DateTime.now(),
                        expiredAt: DateTime.now().add(
                          Duration(
                            minutes: validPeriodInMinutes,
                          ),
                        ),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    );

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
