// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/const/product_button_state.dart';
import 'package:duo_tracker/src/utils/disable_full_screen_ad_support.dart';

/// The enum represents product full screen button state.
enum ProductFullScreenButtonState {
  /// Enabled
  enabled,

  /// Disabled
  disabled,
}

extension ProductFullScreenButtonStateExt on ProductFullScreenButtonState {
  Color getColor({
    required BuildContext context,
  }) {
    switch (this) {
      case ProductFullScreenButtonState.enabled:
        return ProductButtonState.enabled.getColor(context: context);
      case ProductFullScreenButtonState.disabled:
        return ProductButtonState.disabled.getColor(context: context);
    }
  }

  Future<String> getTitle({
    required String title,
  }) async {
    switch (this) {
      case ProductFullScreenButtonState.enabled:
        return ProductButtonState.enabled.getTitle(
          title: title,
          adDisabled: await DisableFullScreenAdSupport.isEnabled(),
        );
      case ProductFullScreenButtonState.disabled:
        return ProductButtonState.disabled.getTitle(
          title: title,
        );
    }
  }
}
