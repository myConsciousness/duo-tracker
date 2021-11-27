// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_product_item.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';

class CommonProductList extends StatelessWidget {
  const CommonProductList({
    Key? key,
    required this.productType,
    required this.disableAdPatterns,
    required this.onPressedButton,
  }) : super(key: key);

  /// The on pressed button
  final Function(
    int price,
    DisableAdProductType producType,
    DisableAdPattern disableAdPattern,
  ) onPressedButton;

  /// The disable ad patterns
  final List<DisableAdPattern> disableAdPatterns;

  /// The product type
  final DisableAdProductType productType;

  List<Widget> _buildProductList() {
    final products = <Widget>[];

    int count = 1;
    List<CommonProductItem> items = [];
    for (final disableAdPattern in disableAdPatterns) {
      items.add(
        CommonProductItem(
          productType: productType,
          disableAdPattern: disableAdPattern,
          onPressedButton: onPressedButton,
        ),
      );

      if (_shouldMakeNewLine(count: count)) {
        products.add(
          _buildProductItems(
            items: List.from(items),
          ),
        );

        items.clear();
      }

      count++;
    }

    return products;
  }

  bool _shouldMakeNewLine({
    required int count,
  }) =>
      count % 2 == 0 || count == disableAdPatterns.length;

  Widget _buildProductItems({
    required List<Widget> items,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      );

  @override
  Widget build(BuildContext context) => Column(
        children: _buildProductList(),
      );
}
