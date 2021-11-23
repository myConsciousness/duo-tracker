// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/flavors.dart';
import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/view/analysis/proficiency_analysis_view.dart';
import 'package:duo_tracker/src/view/folder/folder_tab_view.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:duo_tracker/src/view/settings/settings_tab_view.dart';
import 'package:duo_tracker/src/view/shop/shop_view.dart';
import 'package:duo_tracker/src/view/tips/tips_and_notes_tab_view.dart';
import 'package:duo_tracker/src/view/user/user_account_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_version/new_version.dart';

class DuoTrackerHomeView extends StatefulWidget {
  const DuoTrackerHomeView({Key? key}) : super(key: key);

  @override
  _DuoTrackerHomeViewState createState() => _DuoTrackerHomeViewState();
}

class _DuoTrackerHomeViewState extends State<DuoTrackerHomeView> {
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
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    final newVersion =
        NewVersion(androidId: FlavorConfig.instance.variables['androidId']);
    final status = await newVersion.getVersionStatus();

    if (status!.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogText: status.releaseNotes,
        dialogTitle: 'New Version Is Available!',
        updateButtonText: 'Update Right Now',
        dismissButtonText: 'Skip',
      );
    }
  }

  @override
  Widget build(BuildContext context) => CommonDefaultTabController(
        length: F.isFreeBuild ? 7 : 6,
        labelFontSize: 12.0,
        unselectedLabelFontSize: 11.0,
        tabs: [
          const Tab(icon: Icon(FontAwesomeIcons.listAlt, size: 16)),
          const Tab(icon: Icon(Icons.more, size: 20)),
          const Tab(icon: Icon(FontAwesomeIcons.folderOpen, size: 16)),
          const Tab(icon: Icon(FontAwesomeIcons.chartPie, size: 16)),
          const Tab(icon: Icon(FontAwesomeIcons.userAlt, size: 16)),
          if (F.isFreeBuild)
            const Tab(icon: Icon(FontAwesomeIcons.shoppingCart, size: 16)),
          const Tab(icon: Icon(Icons.settings, size: 20)),
        ],
        body: [
          const OverviewTabView(),
          const TipsAndNotesTabView(),
          const FolderTabView(),
          const ProficiencyAnalysisView(),
          const UserAccountTabView(),
          if (F.isFreeBuild) const ShopView(),
          const SettingsTabView(),
        ],
      );
}
