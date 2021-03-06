// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_flavor/flutter_flavor.dart';

// Project imports:
import 'package:duo_tracker/main.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeModeProvider.getInstance().initialize();

  FlavorConfig(
    variables: {
      'androidId': 'org.thinkit.paid.duotracker',
    },
  );

  F.appFlavor = Flavor.paid;
  runApp(const DuoTracker());
}
