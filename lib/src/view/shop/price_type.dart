// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum that manages price type.
enum PriceType {
  /// The duo tracker point
  duoTrackerPoint,

  /// The legal currency
  legalCurrency
}

extension PriceTypeExt on PriceType {
  /// Returns the code.
  int get code {
    switch (this) {
      case PriceType.duoTrackerPoint:
        return 0;
      case PriceType.legalCurrency:
        return 1;
    }
  }
}
