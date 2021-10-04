// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: ['12FA608E7D2E2A96D30BE9C3D4A6ACA5']);
  await MobileAds.instance.updateRequestConfiguration(configuration);

  F.appFlavor = Flavor.free;
  runApp(const DuoTracker());
}
