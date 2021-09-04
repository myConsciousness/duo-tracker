// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum Flavor {
  FREE,
  PAID,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.FREE:
        return 'Duovoc';
      case Flavor.PAID:
        return 'Duovoc';
      default:
        return 'title';
    }
  }
}
