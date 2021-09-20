// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/security/biometric_authenitication.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:duo_tracker/src/view/passcode_view.dart';
import 'package:flutter/foundation.dart';
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

  Widget _createSettingTitle({
    required String title,
  }) =>
      Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 20,
        ),
      );

  Widget _createListTile({
    required Icon icon,
    required String title,
    String subtitle = '',
    GestureTapCallback? onTap,
  }) =>
      ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle.isEmpty
            ? null
            : Text(
                subtitle,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    final ThemeModeProvider themeModeProvider = Provider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            _createSettingTitle(
              title: 'Theme',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _createListTile(
                    icon: const Icon(Icons.dark_mode),
                    title: 'Use Dark Mode',
                    subtitle:
                        'Switch the theme of app to dark mode. Dark mode consumes less power and is less stressful on your eyes.',
                  ),
                ),
                Switch(
                  value: themeModeProvider.appliedDarkTheme,
                  onChanged: (value) async {
                    super.setState(() {
                      themeModeProvider.notify(appliedDarkTheme: value);
                    });
                  },
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 5),
            _createSettingTitle(
              title: 'Security',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _createListTile(
                    icon: const Icon(Icons.lock),
                    title: 'Use passcode',
                    subtitle:
                        'Restrict access using passcode to pages that may contain confidential information.',
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
                Expanded(
                  child: _createListTile(
                    icon: const Icon(Icons.fingerprint),
                    title: 'Use fingerprint recognition',
                    subtitle:
                        'Restrict access using fingerprint recognition to pages that may contain confidential information.',
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
            _createSettingTitle(
              title: 'Misc',
            ),
            _createListTile(
              icon: const Icon(Icons.share),
              title: 'Share App',
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();

                await Share.share(
                  '''Duo Tracker is the best app to support your learning with Duolingo!
Your language learning will be accelerated with this app!

#Duolingo #DuoTracker #Tracker #Learn #App #Android #DL
https://play.google.com/store/apps/details?id=${packageInfo.packageName}
                      ''',
                  subject: 'This is ${packageInfo.appName}!',
                );
              },
            ),
            _createListTile(
              icon: const Icon(Icons.rate_review),
              title: 'Review App',
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();

                LaunchReview.launch(androidAppId: packageInfo.packageName);
              },
            ),
            _createListTile(
              icon: const Icon(Icons.info),
              title: 'Show Licenses',
              onTap: () async {
                final PackageInfo packageInfo =
                    await PackageInfo.fromPlatform();

                showLicensePage(
                  context: context,
                  applicationName: packageInfo.appName,
                  applicationVersion: packageInfo.version,
                  applicationIcon: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      width: 250.0,
                      height: 250.0,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/icon/bowie_license.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  applicationLegalese:
                      '''Copyright 2021 Kato Shinya, Kato Melissa. All rights reserved.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.''',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
