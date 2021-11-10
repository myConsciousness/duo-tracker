// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_tappable_list_title.dart';
import 'package:duo_tracker/src/view/settings/request_mail_meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppView extends StatefulWidget {
  const AboutAppView({Key? key}) : super(key: key);

  @override
  _AboutAppViewState createState() => _AboutAppViewState();
}

class _AboutAppViewState extends State<AboutAppView> {
  /// The app name
  String _appName = '';

  /// The build version
  String _buildVersion = '';

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

  Future<void> _asyncInitState() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    super.setState(() {
      _appName = packageInfo.appName;
      _buildVersion = '${packageInfo.version}: ${packageInfo.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CommonTappableListTile(
                  icon: const Icon(Icons.app_settings_alt),
                  title: _appName,
                  subtitle: _buildVersion,
                ),
                const CommonDivider(),
                CommonTappableListTile(
                  icon: const Icon(Icons.share),
                  title: 'Share App',
                  onTap: () async {
                    final PackageInfo packageInfo =
                        await PackageInfo.fromPlatform();

                    await Share.share(
                      '''Duo Tracker is the best app to support your learning with Duolingo!
Your language learning will be accelerated with this app!

#Duolingo #DuoTracker #Tracker #Learn #App #Android #DL #Flutter
https://play.google.com/store/apps/details?id=${packageInfo.packageName}
                      ''',
                      subject: 'This is ${packageInfo.appName}!',
                    );
                  },
                ),
                CommonTappableListTile(
                  icon: const Icon(Icons.rate_review),
                  title: 'Review App',
                  onTap: () async {
                    final PackageInfo packageInfo =
                        await PackageInfo.fromPlatform();

                    await LaunchReview.launch(
                        androidAppId: packageInfo.packageName);
                  },
                ),
                CommonTappableListTile(
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
                                image:
                                    AssetImage('assets/icon/bowie_license.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      applicationLegalese:
                          '''Copyright 2021 Kato Shinya, Kato Melissa. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.''',
                    );
                  },
                ),
                const CommonDivider(),
                CommonTappableListTile(
                  icon: const Icon(Icons.mail),
                  title: 'Send Your Opinion',
                  subtitle:
                      'You can directly request new features or improvements to existing features to a developer.',
                  onTap: () async => await FlutterEmailSender.send(
                    Email(
                      recipients: [
                        RequestMailMeta.recipientAddress,
                      ],
                      subject: RequestMailMeta.subject,
                      body: RequestMailMeta.body,
                      isHTML: false,
                    ),
                  ),
                ),
                CommonTappableListTile(
                  icon: const Icon(Icons.people),
                  title: 'About Author',
                  onTap: () async =>
                      await launch('https://github.com/myConsciousness'),
                ),
                if (F.isFreeBuild) const CommonDivider(),
                if (F.isFreeBuild)
                  CommonTappableListTile(
                    icon: const Icon(Icons.store),
                    title: 'Purchase NoAds Version',
                    subtitle:
                        'You can purchase an ad-free version on the Play Store.',
                    onTap: () async => await launch(
                        'https://play.google.com/store/apps/details?id=${FlavorConfig.instance.variables['paidPackageId']}'),
                  ),
              ],
            ),
          ),
        ),
      );
}
