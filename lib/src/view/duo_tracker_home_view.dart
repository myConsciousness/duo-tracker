// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:duo_tracker/src/view/settings/settings_view.dart';
import 'package:duo_tracker/src/view/statistics/statistics_view.dart';
import 'package:duo_tracker/src/view/user/user_account_tab_view.dart';
import 'package:duo_tracker/src/view/user/user_overview_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DuoTrackerHomeView extends StatelessWidget {
  const DuoTrackerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 4,
        labelFontSize: 12.0,
        unselectedLabelFontSize: 11.0,
        tabs: [
          Tab(icon: Icon(FontAwesomeIcons.listAlt, size: 16)),
          Tab(icon: Icon(FontAwesomeIcons.chartPie, size: 16)),
          Tab(icon: Icon(FontAwesomeIcons.userAlt, size: 16)),
          Tab(icon: Icon(Icons.settings)),
        ],
        body: [
          OverviewTabView(),
          StatisticsView(),
          UserAccountTabView(),
          SettingsView(),
        ],
      );
}
