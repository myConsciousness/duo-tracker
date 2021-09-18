// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:duo_tracker/src/view/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class DuoTrackerHomeView extends StatefulWidget {
  const DuoTrackerHomeView({Key? key}) : super(key: key);

  @override
  _DuoTrackerHomeViewState createState() => _DuoTrackerHomeViewState();
}

class _DuoTrackerHomeViewState extends State<DuoTrackerHomeView> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
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
            indicator: DotIndicator(
              color: Theme.of(context).colorScheme.secondary,
              distanceFromCenter: 16,
              radius: 3,
              paintingStyle: PaintingStyle.fill,
            ),
            tabs: const [
              Tab(
                icon: Icon(
                  FontAwesomeIcons.listAlt,
                  size: 16,
                ),
              ),
              // Tab(
              //   icon: Icon(
              //     FontAwesomeIcons.chartPie,
              //     size: 16,
              //   ),
              // ),
              // Tab(
              //   icon: Icon(
              //     FontAwesomeIcons.userAlt,
              //     size: 16,
              //   ),
              // ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              OverviewTabView(),
              // StatisticsView(),
              // UserAccountView(),
              SettingsView(),
            ],
          ),
        ),
      );
}
