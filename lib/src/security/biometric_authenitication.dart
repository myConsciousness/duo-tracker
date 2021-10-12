// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:local_auth/local_auth.dart';

@Deprecated('Not used yet')
class BiometricAuthentication {
  /// The internal constructor.
  BiometricAuthentication._internal();

  /// Returns the singleton instance of [BiometricAuthentication].
  factory BiometricAuthentication.getInstance() => _singletonInstance;

  static final _localAuthentication = LocalAuthentication();

  /// The singleton instance of this [BiometricAuthentication].
  static final _singletonInstance = BiometricAuthentication._internal();

  Future<bool> authenticate({required String reason}) async {
    if (await isBiometricSupported()) {
      final availableBiometricTypes =
          await _localAuthentication.getAvailableBiometrics();

      if (availableBiometricTypes.contains(BiometricType.face) ||
          availableBiometricTypes.contains(BiometricType.fingerprint)) {
        return await _localAuthentication.authenticate(localizedReason: reason);
      }
    }

    return false;
  }

  Future<bool> isBiometricSupported() async {
    final available = await _localAuthentication.canCheckBiometrics;
    final deviceSupported = await _localAuthentication.isDeviceSupported();
    return available && deviceSupported;
  }
}
