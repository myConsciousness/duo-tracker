// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/context/context.dart';
import 'package:duo_tracker/src/utils/disable_all_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_pattern.dart';
import 'package:duo_tracker/src/view/shop/disable_ad_product_type.dart';

class DisableAdContext extends Context<Future<void>> {
  /// Returns the new instance of [DisableAdContext] based on arguments.
  DisableAdContext.from({
    required this.disableAdProductType,
    required this.disableAdPattern,
  });

  /// The disable ad product type
  final DisableAdProductType disableAdProductType;

  /// The disable ad pattern
  final DisableAdPattern disableAdPattern;

  @override
  Future<void> execute() async {
    switch (disableAdProductType) {
      case DisableAdProductType.disbaleFullScreenAd:
        await DisableFullScreenAdSupport.disable(
          disableAdPattern: disableAdPattern,
        );
        return;
      case DisableAdProductType.disableBannerAd:
        await DisableBannerAdSupport.disable(
          disableAdPattern: disableAdPattern,
        );
        return;
      case DisableAdProductType.all:
        await DisableAllAdSupport.disable(
          disableAdPattern: disableAdPattern,
        );
        return;
    }
  }
}
