// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/view/duo_tracker_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DuoTracker extends StatefulWidget {
  const DuoTracker({Key? key}) : super(key: key);

  @override
  _DuoTrackerState createState() => _DuoTrackerState();
}

class _DuoTrackerState extends State<DuoTracker> {
  /// The sheme mode provider
  final _themeModeProvider = ThemeModeProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Fix app orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                    : Colors.white,
                systemNavigationBarIconBrightness:
                    _themeModeProvider.appliedDarkTheme
                        ? Brightness.dark
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
