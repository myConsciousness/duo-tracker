/// Copyright 2021 Kato Shinya.
///
/// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
/// in compliance with the License. You may obtain a copy of the License at
///
///     http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software distributed under the License
/// is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
/// or implied. See the License for the specific language governing permissions and limitations under
/// the License.

import 'package:local_auth/local_auth.dart';

class BiometricAuthentication {
  /// The singleton instance of this [BiometricAuthentication].
  static final BiometricAuthentication _singletonInstance =
      BiometricAuthentication._internal();

  /// The internal constructor.
  BiometricAuthentication._internal();

  /// Returns the singleton instance of [BiometricAuthentication].
  factory BiometricAuthentication.getInstance() => _singletonInstance;

  static final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate({required String reason}) async {
    if (await this.isBiometricSupported()) {
      final List<BiometricType> availableBiometricTypes =
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
