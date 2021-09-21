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
        return 'Duo Tracker';
      case Flavor.paid:
        return 'Duo Tracker';
      default:
        return 'title';
    }
  }

  static bool get isFreeBuild => appFlavor == Flavor.free;
  static bool get isPaidBuild => appFlavor == Flavor.paid;
}
