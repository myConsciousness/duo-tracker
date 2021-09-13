// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/utils/size_config.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:duo_tracker/src/view/settings/settings_view.dart';
import 'package:duo_tracker/src/view/statistics/statistics_view.dart';
import 'package:duo_tracker/src/view/user/user_account_view.dart';
import 'package:flutter/material.dart';

class DuoTrackerHomeView extends StatefulWidget {
  const DuoTrackerHomeView({Key? key}) : super(key: key);

  @override
  _DuoTrackerHomeViewState createState() => _DuoTrackerHomeViewState();
}

class _DuoTrackerHomeViewState extends State<DuoTrackerHomeView> {
  double getProportionHeight(double inputHeight) {
    final screenHeight = SizeConfig.screenHeight;
    return (inputHeight / 812.0) * screenHeight;
  }

  double getProportionWidth(double inputWidth) {
    final screenWidth = SizeConfig.screenWidth;
    return (inputWidth / 375.0) * screenWidth;
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            isScrollable: false,
            unselectedLabelColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            unselectedLabelStyle: const TextStyle(fontSize: 11.0),
            labelColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(fontSize: 12.0),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorWeight: 2.0,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: getProportionWidth(3),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            tabs: const [
              Tab(icon: Icon(Icons.list_alt)),
              Tab(icon: Icon(Icons.bar_chart)),
              Tab(icon: Icon(Icons.account_circle)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          body: const TabBarView(
            children: [
              OverviewTabView(),
              StatisticsView(),
              UserAccountView(),
              SettingsView(),
            ],
          ),
        ),
      );
}
