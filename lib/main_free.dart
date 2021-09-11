// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flavors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  FlavorConfig(
    variables: {
      'paidUrl':
          'https://play.google.com/store/apps/details?id=org.thinkit.paid.duovoc',
    },
  );

  F.appFlavor = Flavor.free;
  runApp(const DuoTracker());
}
