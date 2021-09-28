// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum DisableFullScreenType {
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

extension DisableFullScreenTypeExt on DisableFullScreenType {
  /// Returns the code
  int get code {
    switch (this) {
      case DisableFullScreenType.m30:
        return 0;
      case DisableFullScreenType.h1:
        return 1;
      case DisableFullScreenType.h3:
        return 2;
      case DisableFullScreenType.h6:
        return 3;
      case DisableFullScreenType.h12:
        return 4;
      case DisableFullScreenType.h24:
        return 5;
    }
  }

  /// Returns the time limit in minutes
  int get timeLimit {
    switch (this) {
      case DisableFullScreenType.m30:
        return 30;
      case DisableFullScreenType.h1:
        return 60;
      case DisableFullScreenType.h3:
        return 180;
      case DisableFullScreenType.h6:
        return 360;
      case DisableFullScreenType.h12:
        return 720;
      case DisableFullScreenType.h24:
        return 1440;
    }
  }

  static DisableFullScreenType toEnum({
    required int code,
  }) {
    for (final disableFullScreenType in DisableFullScreenType.values) {
      if (disableFullScreenType.code == code) {
        return disableFullScreenType;
      }
    }

    return DisableFullScreenType.m30;
  }
}
