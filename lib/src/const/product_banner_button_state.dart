// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/const/product_button_state.dart';
import 'package:duo_tracker/src/utils/disable_banner_ad_support.dart';
import 'package:flutter/material.dart';

/// The enum represents product banner button state.
enum ProductBannerButtonState {
  /// Enabled
  enabled,

  /// Disabled
  disabled,
}

extension ProductBannerButtonStateExt on ProductBannerButtonState {
  Color getColor({
    required BuildContext context,
  }) {
    switch (this) {
      case ProductBannerButtonState.enabled:
        return ProductButtonState.enabled.getColor(context: context);
      case ProductBannerButtonState.disabled:
        return ProductButtonState.disabled.getColor(context: context);
    }
  }

  Future<String> getTitle({
    required String title,
  }) async {
    switch (this) {
      case ProductBannerButtonState.enabled:
        return ProductButtonState.enabled.getTitle(
          title: title,
          adDisabled: await DisableBannerAdSupport.isEnabled(),
        );
      case ProductBannerButtonState.disabled:
        return ProductButtonState.disabled.getTitle(
          title: title,
        );
    }
  }
}
