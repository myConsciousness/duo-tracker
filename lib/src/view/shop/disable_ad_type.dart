// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum DisableAdType {
  /// 30 minutes
  m30,

  /// A hour
  h1,

  /// 3 hours
  h3,

  /// 6 hours
  h6,

  /// 12 hours
  h12,

  /// 24 hours
  h24
}

extension DisableAdTypeExt on DisableAdType {
  /// Returns the code
  int get code {
    switch (this) {
      case DisableAdType.m30:
        return 0;
      case DisableAdType.h1:
        return 1;
      case DisableAdType.h3:
        return 2;
      case DisableAdType.h6:
        return 3;
      case DisableAdType.h12:
        return 4;
      case DisableAdType.h24:
        return 5;
    }
  }

  /// Returns the time limit in minutes
  int get timeLimit {
    switch (this) {
      case DisableAdType.m30:
        return 30;
      case DisableAdType.h1:
        return 60;
      case DisableAdType.h3:
        return 180;
      case DisableAdType.h6:
        return 360;
      case DisableAdType.h12:
        return 720;
      case DisableAdType.h24:
        return 1440;
    }
  }

  static DisableAdType toEnum({
    required int code,
  }) {
    for (final disableAdType in DisableAdType.values) {
      if (disableAdType.code == code) {
        return disableAdType;
      }
    }

    return DisableAdType.m30;
  }
}
