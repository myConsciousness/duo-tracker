// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/security/biometric_authenitication.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:duo_tracker/src/view/passcode_view.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _activeFingerprintRecognition = false;
  bool _activePasscodeLock = false;

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
    _asyncInitState();
  }

  void _updateUseFingerprintRecognition(final bool active) async {
    await CommonSharedPreferencesKey.useFingerprintRecognition.setBool(active);

    super.setState(() {
      _activeFingerprintRecognition = active;
    });
  }

  void _asyncInitState() async {
    final bool initUseFingerprintRecognition =
        await CommonSharedPreferencesKey.useFingerprintRecognition.getBool();
    final bool initUsePasscodeLock =
        await CommonSharedPreferencesKey.usePasscodeLock.getBool();

    super.setState(() {
      _activePasscodeLock = initUsePasscodeLock;
      _activeFingerprintRecognition = initUseFingerprintRecognition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModeProvider themeModeProvider = Provider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Theme',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: Text(
                      'Use Dark Mode',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Restrict access using passcode to pages that may contain confidential information.',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                Switch(
                  value: themeModeProvider.appliedDarkTheme,
                  onChanged: (value) {
                    super.setState(() {
                      themeModeProvider.notify(appliedDarkTheme: value);
                    });
                  },
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 5),
            Text(
              'Security',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Use passcode'),
                    subtitle: Text(
                        'Restrict access using passcode to pages that may contain confidential information.'),
                  ),
                ),
                Switch(
                  value: _activePasscodeLock,
                  onChanged: (_) async {
                    final bool usingPasscodeLock =
                        await CommonSharedPreferencesKey.usePasscodeLock
                            .getBool();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasscodeView(
                          title: usingPasscodeLock
                              ? 'Enter passcode'
                              : 'Set passcode',
                          passwordEnteredCallback:
                              (final String passcode) async {
                            final String encryptedPasscode =
                                Encryption.encode(value: passcode);

                            if (usingPasscodeLock) {
                              final String storedPasscode =
                                  await CommonSharedPreferencesKey.passcode
                                      .getString();

                              if (encryptedPasscode == storedPasscode) {
                                // Reset passcode if it was verified
                                await CommonSharedPreferencesKey.passcode
                                    .setString('');
                                await CommonSharedPreferencesKey.usePasscodeLock
                                    .setBool(false);

                                Navigator.pop(context);

                                super.setState(() {
                                  _activePasscodeLock = false;
                                });
                              } else {
                                InfoSnackbar.from(context: context).show(
                                    content: 'The passcode is incorrect.');
                              }
                            } else {
                              await CommonSharedPreferencesKey.passcode
                                  .setString(encryptedPasscode);
                              await CommonSharedPreferencesKey.usePasscodeLock
                                  .setBool(true);

                              Navigator.pop(context);

                              super.setState(() {
                                _activePasscodeLock = true;
                              });
                            }
                          },
                          cancelCallback: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Expanded(
                  child: ListTile(
                    leading: Icon(Icons.fingerprint),
                    title: Text('Use fingerprint recognition'),
                    subtitle: Text(
                        'Restrict access using fingerprint recognition to pages that may contain confidential information.'),
                  ),
                ),
                Switch(
                  value: _activeFingerprintRecognition,
                  onChanged: (final bool active) async {
                    if (!await BiometricAuthentication.getInstance()
                        .isBiometricSupported()) {
                      InfoSnackbar.from(context: context)
                          .show(content: '''This feature cannot be used.
The device does not support biometric feature.''');
                      return;
                    }

                    final bool usingFingerRecognition =
                        await CommonSharedPreferencesKey
                            .useFingerprintRecognition
                            .getBool();

                    if (usingFingerRecognition) {
                      final bool authenticated = await BiometricAuthentication
                              .getInstance()
                          .authenticate(
                              reason:
                                  'Biometric authentication has been set up. Authenticate to apply the change.');

                      if (authenticated) {
                        _updateUseFingerprintRecognition(active);
                      }
                    } else {
                      _updateUseFingerprintRecognition(active);
                    }
                  },
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 5),
            Text(
              'Misc',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share App'),
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();

                await Share.share(
                  // TODO Share時のメッセージ
                  '''${packageInfo.appName} is the most beautiful, easy and intuitive application about QR Code!

#MrQR #QRCodeScanner #QRCodeGenerator #QRCode #app #android
https://play.google.com/store/apps/details?id=${packageInfo.packageName}
                      ''',
                  subject: 'This is ${packageInfo.appName}!',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('Review App'),
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();

                LaunchReview.launch(androidAppId: packageInfo.packageName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Show Licenses'),
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();

                showLicensePage(
                    context: context,
                    applicationName: packageInfo.appName,
                    applicationVersion: packageInfo.version,
                    applicationIcon: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset('assets/icon/bowie_license.png'),
                    ),
                    applicationLegalese:
                        '''Copyright 2021 Kato Shinya, Kato Melissa. All rights reserved.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.''');
              },
            ),
          ],
        ),
      ),
    );
  }
}
