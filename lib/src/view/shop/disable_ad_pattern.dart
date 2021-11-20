// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum DisableAdPattern {
  /// 5 minutes
  m5,

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
      case DisableAdPattern.m5:
        return 900;
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

  /// Returns the limit in minutes
  int get limit {
    switch (this) {
      case DisableAdPattern.m5:
        return 5;
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

  String get name {
    switch (this) {
      case DisableAdPattern.m5:
        return '5 minutes';
      case DisableAdPattern.m30:
        return '30 minutes';
      case DisableAdPattern.h1:
        return '1 hour';
      case DisableAdPattern.h3:
        return '3 hours';
      case DisableAdPattern.h6:
        return '6 hours';
      case DisableAdPattern.h12:
        return '12 hours';
      case DisableAdPattern.h24:
        return '24 hours';
    }
  }

  int get price {
    switch (this) {
      case DisableAdPattern.m5:
        return 0;
      case DisableAdPattern.m30:
        return 5;
      case DisableAdPattern.h1:
        return 10;
      case DisableAdPattern.h3:
        return 20;
      case DisableAdPattern.h6:
        return 35;
      case DisableAdPattern.h12:
        return 50;
      case DisableAdPattern.h24:
        return 65;
    }
  }

  bool hasPrice() {
    return price > 0;
  }

  static List<DisableAdPattern> get paidPatterns {
    final patterns = <DisableAdPattern>[];

    for (final disableAdPattern in DisableAdPattern.values) {
      if (disableAdPattern.hasPrice()) {
        patterns.add(disableAdPattern);
      }
    }

    return patterns;
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
