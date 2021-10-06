// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.paid;

  FlavorConfig(
    variables: {
      'androidId': 'org.thinkit.paid.duotracker',
    },
  );

  runApp(const DuoTracker());
}
