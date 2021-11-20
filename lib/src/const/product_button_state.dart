// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// The enum represents product button state.
enum ProductButtonState {
  /// Enabled
  enabled,

  /// Disabled
  disabled,
}

extension ProductButtonStateExt on ProductButtonState {
  Color getColor({
    required BuildContext context,
  }) {
    switch (this) {
      case ProductButtonState.enabled:
        return Theme.of(context).colorScheme.secondaryVariant;
      case ProductButtonState.disabled:
        return Colors.grey;
    }
  }

  String getTitle({
    String enabledName = '',
    String disabledName = '',
  }) {
    switch (this) {
      case ProductButtonState.enabled:
        return enabledName.isEmpty ? 'Enabled' : enabledName;
      case ProductButtonState.disabled:
        return disabledName.isEmpty ? 'Disabled' : disabledName;
    }
  }
}
