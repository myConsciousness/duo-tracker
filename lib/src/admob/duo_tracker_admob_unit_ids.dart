// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:admob_unit_ids/admob_unit_ids.dart';

/// The class that manages the AdMob unit ids of Duo Tracker.
class DuoTrackerAdmobUnitIds extends AdmobUnitIDs {
  /// The internal default constructor.
  DuoTrackerAdmobUnitIds._internal();

  /// Returns the singleton instance of [DuoTrackerAdmobUnitIds].
  factory DuoTrackerAdmobUnitIds.getInstance() => _singletonInstance;

  /// The singleton instance of [DuoTrackerAdmobUnitIds].
  static final DuoTrackerAdmobUnitIds _singletonInstance =
      DuoTrackerAdmobUnitIds._internal();

  @override
  String get releaseAppOpen => throw UnimplementedError();

  @override
  String get releaseBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7168775731316469/3113896382';
    }

    throw UnimplementedError();
  }

  @override
  String get releaseInterstitial {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7168775731316469/7983079689';
    }

    throw UnimplementedError();
  }

  @override
  String get releaseInterstitialVideo => throw UnimplementedError();

  @override
  String get releaseNativeAdvanced => throw UnimplementedError();

  @override
  String get releaseNativeAdvancedVideo => throw UnimplementedError();

  @override
  String get releaseRewarded {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7168775731316469/3386193275';
    }

    throw UnimplementedError();
  }

  @override
  String get releaseRewardedInterstitial {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7168775731316469/6359840978';
    }

    throw UnimplementedError();
  }
}
