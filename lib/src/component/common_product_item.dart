// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/const/product_button_state.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/utils/disable_all_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:flutter/material.dart';

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

  Future<Color> _getDisableAdPurchaseButtonColor({
    required DisableAdProductType productType,
    required DisableAdPattern disableAdPattern,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        final buttonState =
            await DisableFullScreenAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return buttonState.getColor(context: context);
      case DisableAdProductType.disableBannerAd:
        final buttonState = await DisableBannerAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return buttonState.getColor(context: context);
      case DisableAdProductType.all:
        final buttonState = await DisableAllAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return buttonState.getColor(context: context);
    }
  }

  Widget _buildDisableAdPurchaseButton({
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

  Future<String> _buildPurchaseButtonTitle({
    required DisableAdProductType productType,
    required DisableAdPattern disableAdPattern,
    required String defaultTitle,
  }) async {
    switch (productType) {
      case DisableAdProductType.disbaleFullScreenAd:
        final buttonState =
            await DisableFullScreenAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return buttonState.getTitle(disabledName: defaultTitle);
      case DisableAdProductType.disableBannerAd:
        final buttonState = await DisableBannerAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return buttonState.getTitle(disabledName: defaultTitle);
      case DisableAdProductType.all:
        final buttonState = await DisableAllAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return buttonState.getTitle(disabledName: defaultTitle);
    }
  }

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: FutureBuilder(
                    future: _buildPurchaseButtonTitle(
                      productType: widget.productType,
                      disableAdPattern: widget.disableAdPattern,
                      defaultTitle: '$_price Points',
                    ),
                    builder:
                        (BuildContext context, AsyncSnapshot titleSnapshot) {
                      if (!titleSnapshot.hasData) {
                        return const Loading();
                      }

                      return FutureBuilder(
                        future: _getDisableAdPurchaseButtonColor(
                          productType: widget.productType,
                          disableAdPattern: widget.disableAdPattern,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot buttonColorSnapshot) {
                          if (!buttonColorSnapshot.hasData) {
                            return const Loading();
                          }

                          return _buildDisableAdPurchaseButton(
                            title: titleSnapshot.data,
                            color: buttonColorSnapshot.data,
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
}
