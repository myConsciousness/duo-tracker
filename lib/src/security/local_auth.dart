// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/security/biometric_authenitication.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:duo_tracker/src/view/common_passcode_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@Deprecated('Not used yet')
class LocalAuth {
  static Future<void> execute({
    required BuildContext context,
  }) async {
    final useFingerprintRecognition =
        await CommonSharedPreferencesKey.useFingerprintRecognition.getBool();
    final usePasscodeLock =
        await CommonSharedPreferencesKey.usePasscodeLock.getBool();

    if (useFingerprintRecognition && usePasscodeLock) {
      await BiometricAuthentication.getInstance().authenticate(reason: '');
    } else if (useFingerprintRecognition) {
      await BiometricAuthentication.getInstance().authenticate(reason: '');
    } else if (usePasscodeLock) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommonPasscodeView(
            title: 'Enter passcode',
            passwordEnteredCallback: (final passcode) async {
              final encryptedPasscode = Encryption.encode(value: passcode);
              final storedPasscode =
                  await CommonSharedPreferencesKey.passcode.getString();

              if (encryptedPasscode == storedPasscode) {
                return;
              } else {
                InfoSnackbar.from(context: context)
                    .show(content: 'Wrong passcode.');
              }
            },
            cancelCallback: () {
              // Terminate app
              SystemNavigator.pop();
            },
          ),
        ),
      );
    }
  }
}
