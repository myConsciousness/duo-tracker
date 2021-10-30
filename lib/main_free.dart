// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/main.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/admob/rewarded_interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeModeProvider.getInstance().initialize();
  await MobileAds.instance.initialize();

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: ['12FA608E7D2E2A96D30BE9C3D4A6ACA5']);
  await MobileAds.instance.updateRequestConfiguration(configuration);

  await InterstitialAdResolver.getInstance().loadInterstitialAd();
  await RewardedAdResolver.getInstance().loadRewardedAd();

  FlavorConfig(
    variables: {
      'androidId': 'org.thinkit.free.duotracker',
    },
  );

  F.appFlavor = Flavor.free;
  runApp(const DuoTracker());
}
