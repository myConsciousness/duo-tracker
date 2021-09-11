// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum Flavor {
  free,
  paid,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.free:
        return 'Duovoc';
      case Flavor.paid:
        return 'Duovoc';
      default:
        return 'title';
    }
  }
}
