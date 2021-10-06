// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app_review/app_review.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_utils.dart';
import 'package:duo_tracker/src/admob/rewarded_interstitial_ad_resolver.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/view/duo_tracker_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

class DuoTracker extends StatefulWidget {
  const DuoTracker({Key? key}) : super(key: key);

  @override
  _DuoTrackerState createState() => _DuoTrackerState();
}

class _DuoTrackerState extends State<DuoTracker> with WidgetsBindingObserver {
  /// The interstitial ad resolver
  final _interstitialAdResolver = InterstitialAdResolver.getInstance();

  /// The rewarded ad resolver
  final _rewardedAdResolver = RewardedAdResolver.getInstance();

  /// The sheme mode provider
  final _themeModeProvider = ThemeModeProvider();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await InterstitialAdUtils.showInterstitialAd(
        sharedPreferencesKey: InterstitialAdSharedPreferencesKey.countOpenApp,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    _asyncInitState();

    // Fix app orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _asyncInitState() async {
    await _interstitialAdResolver.loadInterstitialAd();
    await _rewardedAdResolver.loadRewardedAd();

    await InterstitialAdUtils.showInterstitialAd(
      sharedPreferencesKey: InterstitialAdSharedPreferencesKey.countOpenApp,
    );

    final int datetimeSinceEpock =
        await CommonSharedPreferencesKey.datetimeLastShowedAppReview.getInt();

    if (datetimeSinceEpock == -1) {
      /// First time app is launched
      await CommonSharedPreferencesKey.datetimeLastShowedAppReview
          .setInt(DateTime.now().millisecondsSinceEpoch);
      await AppReview.requestReview;
    } else {
      final datetimeLastShowed =
          DateTime.fromMillisecondsSinceEpoch(datetimeSinceEpock);

      if (DateTime.now().difference(datetimeLastShowed).inDays.abs() >= 7) {
        await AppReview.requestReview;
      }
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _themeModeProvider,
        child: Consumer<ThemeModeProvider>(
          builder: (context, _, __) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: _themeModeProvider.appliedDarkTheme
                    ? Colors.grey[800]!
                    : Colors.blue,
                systemNavigationBarColor: _themeModeProvider.appliedDarkTheme
                    ? Colors.grey[850]!
                    : Colors.grey[50]!,
                systemNavigationBarIconBrightness:
                    _themeModeProvider.appliedDarkTheme
                        ? Brightness.light
                        : Brightness.dark,
              ),
            );

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: _themeModeProvider.appliedDarkTheme
                    ? Brightness.dark
                    : Brightness.light,
                typography: Typography.material2018(),
                textTheme: GoogleFonts.latoTextTheme(
                  _themeModeProvider.appliedDarkTheme
                      ? Typography.whiteMountainView
                      : Typography.blackMountainView,
                ),
              ),
              home: const DuoTrackerHomeView(),
            );
          },
        ),
      );
}
