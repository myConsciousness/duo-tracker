// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_tappable_list_title.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/utils/version_status_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoListTile extends StatelessWidget {
  const AppInfoListTile({Key? key}) : super(key: key);

  Future<VersionStatusWrapper> _fetchAppVersionStatus() async {
    if (!await Network.isConnected()) {
      return VersionStatusWrapper.from(
        status: null,
      );
    }

    final newVersion =
        NewVersion(androidId: FlavorConfig.instance.variables['androidId']);

    return VersionStatusWrapper.from(
      status: await newVersion.getVersionStatus(),
    );
  }

  String _buildAppInfoSubtitle({
    required VersionStatus? versionStatus,
    required PackageInfo packageInfo,
  }) {
    if (versionStatus == null) {
      return '${packageInfo.version}: ${packageInfo.buildNumber}';
    }

    if (versionStatus.canUpdate) {
      return '${packageInfo.version}: ${packageInfo.buildNumber} (Can be updated to ${versionStatus.storeVersion})';
    }

    return '${packageInfo.version}: ${packageInfo.buildNumber} (Latest)';
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }

          final packageInfo = snapshot.data;

          return FutureBuilder(
            future: _fetchAppVersionStatus(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final versionStatus = snapshot.data.status;

              return CommonTappableListTile(
                icon: const Icon(Icons.app_settings_alt),
                title: packageInfo.appName,
                subtitle: _buildAppInfoSubtitle(
                  versionStatus: versionStatus,
                  packageInfo: packageInfo,
                ),
                onTap: () async {
                  if (versionStatus == null) {
                    await showNetworkErrorDialog(context: context);
                    return;
                  }

                  if (!versionStatus.canUpdate) {
                    InfoSnackbar.from(context: context)
                        .show(content: 'The application is up to date!');
                    return;
                  }

                  await launch(versionStatus.appStoreLink);
                },
              );
            },
          );
        },
      );
}
