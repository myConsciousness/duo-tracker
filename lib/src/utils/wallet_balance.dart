// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/const/operand.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

/// The class that represents wallet balance.
class WalletBalance {
  /// The internal constructor.
  WalletBalance._internal();

  /// Returns the singleton instance of [WalletBalance].
  factory WalletBalance.getInstance() => _singletonInstance;

  /// The singleton instance of this [WalletBalance].
  static final _singletonInstance = WalletBalance._internal();

  /// The current point
  int _point = 0;

  /// Returns current point.
  int get point => _point;

  /// Load the points user currently have.
  Future<void> loadCurrentPoint() async {
    _point = await CommonSharedPreferencesKey.rewardPoint.getInt(
      defaultValue: 0,
    );
  }

  /// Refresh the wallet balance by [operand] and [change].
  Future<void> refresh({
    required Operand operand,
    required int change,
  }) async {
    switch (operand) {
      case Operand.plus:
        await CommonSharedPreferencesKey.rewardPoint.setInt(point + change);
        break;
      case Operand.minus:
        await CommonSharedPreferencesKey.rewardPoint.setInt(point - change);
        break;
    }

    await loadCurrentPoint();
  }
}
