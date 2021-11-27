// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_dialog_cancel_button.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/common_product_detail_card.dart';
import 'package:duo_tracker/src/component/snackbar/success_snack_bar.dart';
import 'package:duo_tracker/src/repository/model/purchase_history_model.dart';
import 'package:duo_tracker/src/repository/service/purchase_history_service.dart';
import 'package:duo_tracker/src/view/shop/price_type.dart';

/// The dialog
late AwesomeDialog _dialog;

/// The purchase history service
final _purchaseHistoryService = PurchaseHistoryService.getInstance();

Future<T?> showPurchaseDialog<T>({
  required BuildContext context,
  required String productName,
  required int price,
  required int validPeriodInMinutes,
  required Function onPressedOk,
}) async {
  _dialog = _buildDialog(
    context: context,
    productName: productName,
    price: price,
    validPeriodInMinutes: validPeriodInMinutes,
    onPressedOk: onPressedOk,
  );

  await _dialog.show();
}

AwesomeDialog _buildDialog({
  required BuildContext context,
  required String productName,
  required int price,
  required int validPeriodInMinutes,
  required Function onPressedOk,
}) =>
    AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.QUESTION,
      btnOkColor: Theme.of(context).colorScheme.secondary,
      body: _buildDialogBody(
        context: context,
        productName: productName,
        price: price,
        validPeriodInMinutes: validPeriodInMinutes,
        onPressedOk: onPressedOk,
      ),
    );

Widget _buildDialogBody({
  required BuildContext context,
  required String productName,
  required int price,
  required int validPeriodInMinutes,
  required Function onPressedOk,
}) =>
    StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const CommonDialogTitle(title: 'Purchase Confirmation'),
                const SizedBox(
                  height: 25,
                ),
                CommonProductDetailCard(
                  productName: productName,
                  validPeriodInMinutes: validPeriodInMinutes,
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonDialogSubmitButton(
                  title: 'Confirm',
                  pressEvent: () async {
                    await onPressedOk.call();

                    final now = DateTime.now();
                    await _purchaseHistoryService.insert(
                      PurchaseHistory.from(
                        productName: productName,
                        price: price,
                        priceType: PriceType.duoTrackerPoint.code,
                        validPeriodInMinutes: validPeriodInMinutes,
                        purchasedAt: now,
                        expiredAt: now.add(
                          Duration(
                            minutes: validPeriodInMinutes,
                          ),
                        ),
                        createdAt: now,
                        updatedAt: now,
                      ),
                    );

                    SuccessSnackBar.from(context: context).show(
                      content:
                          'Purchase completed. You can check the information from the history.',
                    );

                    _dialog.dismiss();
                  },
                ),
                CommonDialogCancelButton(
                  onPressEvent: () async => await _dialog.dismiss(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
