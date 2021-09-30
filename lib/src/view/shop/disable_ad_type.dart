// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum DisableAdPattern {
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

extension DisableAdPatternExt on DisableAdPattern {
  /// Returns the code
  int get code {
    switch (this) {
      case DisableAdPattern.m30:
        return 0;
      case DisableAdPattern.h1:
        return 1;
      case DisableAdPattern.h3:
        return 2;
      case DisableAdPattern.h6:
        return 3;
      case DisableAdPattern.h12:
        return 4;
      case DisableAdPattern.h24:
        return 5;
    }
  }

  /// Returns the time limit in minutes
  int get timeLimit {
    switch (this) {
      case DisableAdPattern.m30:
        return 30;
      case DisableAdPattern.h1:
        return 60;
      case DisableAdPattern.h3:
        return 180;
      case DisableAdPattern.h6:
        return 360;
      case DisableAdPattern.h12:
        return 720;
      case DisableAdPattern.h24:
        return 1440;
    }
  }

  static DisableAdPattern toEnum({
    required int code,
  }) {
    for (final disableAdPattern in DisableAdPattern.values) {
      if (disableAdPattern.code == code) {
        return disableAdPattern;
      }
    }

    return DisableAdPattern.m30;
  }
}
