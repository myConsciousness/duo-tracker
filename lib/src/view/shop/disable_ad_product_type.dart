// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum that manages product type.
enum DisableAdProductType {
  /// The diable full screen ad
  disbaleFullScreenAd,

  /// The disable banner ad
  disableBannerAd,

  /// All ads
  all
}

extension DisableAdProductTypeExt on DisableAdProductType {
  int get priceWeight {
    switch (this) {
      case DisableAdProductType.disbaleFullScreenAd:
        return 1;
      case DisableAdProductType.disableBannerAd:
        return 1;
      case DisableAdProductType.all:
        return 2;
    }
  }

  String get name {
    switch (this) {
      case DisableAdProductType.disbaleFullScreenAd:
        return 'Disable Full Screen Ads';
      case DisableAdProductType.disableBannerAd:
        return 'Disable Banner Ads';
      case DisableAdProductType.all:
        return 'Disable All Ads';
    }
  }
}
