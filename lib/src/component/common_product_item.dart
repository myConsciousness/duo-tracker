// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/context/product_button_color_context.dart';
import 'package:duo_tracker/src/context/purchase_btton_title_context.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';

class CommonProductItem extends StatefulWidget {
  const CommonProductItem({
    Key? key,
    required this.productType,
    required this.disableAdPattern,
    required this.onPressedButton,
  }) : super(key: key);

  /// The on pressed button
  final Function(
    int price,
    DisableAdProductType producType,
    DisableAdPattern disableAdPattern,
  ) onPressedButton;

  /// The disable ad pattern
  final DisableAdPattern disableAdPattern;

  /// The product type
  final DisableAdProductType productType;

  @override
  _CommonProductItemState createState() => _CommonProductItemState();
}

class _CommonProductItemState extends State<CommonProductItem> {
  /// The price
  late int _price;

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
    _price = widget.disableAdPattern.price * widget.productType.priceWeight;
  }

  Widget _buildProductButton({
    required String title,
    required Color color,
  }) =>
      AnimatedButton(
        isFixedHeight: false,
        text: title,
        color: color,
        pressEvent: () => widget.onPressedButton.call(
          _price,
          widget.productType,
          widget.disableAdPattern,
        ),
      );

  Widget _buildPurchaseButton() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: FutureBuilder(
          future: PurchaseButtonTitleContext.from(
            defaultTitle: '$_price Points',
            disableAdProductType: widget.productType,
            disableAdPattern: widget.disableAdPattern,
          ).execute(),
          builder: (BuildContext context, AsyncSnapshot titleSnapshot) {
            if (!titleSnapshot.hasData) {
              return const Loading();
            }

            return FutureBuilder(
              future: ProductButtonColorContext.from(
                context: context,
                disableAdProductType: widget.productType,
                disableAdPattern: widget.disableAdPattern,
              ).execute(),
              builder:
                  (BuildContext context, AsyncSnapshot buttonColorSnapshot) {
                if (!buttonColorSnapshot.hasData) {
                  return const Loading();
                }

                return _buildProductButton(
                  title: titleSnapshot.data,
                  color: buttonColorSnapshot.data,
                );
              },
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.disableAdPattern.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildPurchaseButton(),
              ],
            ),
          ),
        ),
      );
}
