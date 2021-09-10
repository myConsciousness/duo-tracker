// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:admob_unit_ids/admob_unit_ids.dart';

/// The class that manages the AdMob unit ids of Mr.QR.
class DuovocAdmobUnitIds extends AdmobUnitIDs {
  /// The internal default constructor.
  DuovocAdmobUnitIds._internal();

  /// Returns the singleton instance of [DuovocAdmobUnitIds].
  factory DuovocAdmobUnitIds.getInstance() => _singletonInstance;

  /// The singleton instance of [DuovocAdmobUnitIds].
  static final DuovocAdmobUnitIds _singletonInstance =
      DuovocAdmobUnitIds._internal();

  @override
  String get releaseAppOpen => throw UnimplementedError();

  @override
  String get releaseBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7168775731316469/7261516225';
    }

    throw UnimplementedError();
  }

  @override
  String get releaseInterstitial {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7168775731316469/3809356370';
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
  String get releaseRewarded => throw UnimplementedError();

  @override
  String get releaseRewardedInterstitial => throw UnimplementedError();
}
