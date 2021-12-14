// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

// Project imports:
import 'package:duo_tracker/main.dart';
import 'package:duo_tracker/src/admob/interstitial_ad.dart';
import 'package:duo_tracker/src/admob/rewarded_ad.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/utils/wallet_balance.dart';
import 'flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeModeProvider.getInstance().initialize();
  await admob.MobileAds.instance.initialize();

  final configuration = admob.RequestConfiguration(
    testDeviceIds: ['12FA608E7D2E2A96D30BE9C3D4A6ACA5'],
    tagForChildDirectedTreatment: admob.TagForChildDirectedTreatment.yes,
    maxAdContentRating: admob.MaxAdContentRating.g,
  );

  await admob.MobileAds.instance.updateRequestConfiguration(configuration);

  await WalletBalance.getInstance().loadCurrentPoint();
  await InterstitialAd.instance.load();
  await RewardedAd.instance.load();

  FlavorConfig(
    variables: {
      'androidId': 'org.thinkit.free.duotracker',
      'paidPackageId': 'org.thinkit.paid.duotracker',
    },
  );

  F.appFlavor = Flavor.free;
  runApp(const DuoTracker());
}
