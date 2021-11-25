// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/context/context.dart';
import 'package:duo_tracker/src/utils/disable_all_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';
import 'package:duo_tracker/src/const/product_banner_button_state.dart';
import 'package:duo_tracker/src/const/product_full_screen_button_state.dart';
import 'package:duo_tracker/src/const/product_all_button_state.dart';

class PurchaseButtonTitleContext extends Context<Future<String>> {
  /// Returns the new instance of [PurchaseButtonTitleContext] based on arguments.
  PurchaseButtonTitleContext.from({
    required this.defaultTitle,
    required this.disableAdProductType,
    required this.disableAdPattern,
  });

  /// The default title
  final String defaultTitle;

  /// The disable ad product type
  final DisableAdProductType disableAdProductType;

  /// The disable ad pattern
  final DisableAdPattern disableAdPattern;

  @override
  Future<String> execute() async {
    switch (disableAdProductType) {
      case DisableAdProductType.disbaleFullScreenAd:
        final buttonState =
            await DisableFullScreenAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return await buttonState.getTitle(title: defaultTitle);
      case DisableAdProductType.disableBannerAd:
        final buttonState = await DisableBannerAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return await buttonState.getTitle(title: defaultTitle);
      case DisableAdProductType.all:
        final buttonState = await DisableAllAdSupport.getProductButtonState(
          disableAdPattern: disableAdPattern,
        );

        return await buttonState.getTitle(title: defaultTitle);
    }
  }
}
