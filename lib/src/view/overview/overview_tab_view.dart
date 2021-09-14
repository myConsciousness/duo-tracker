// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/utils/size_config.dart';
import 'package:duo_tracker/src/view/overview/overview_view.dart';
import 'package:flutter/material.dart';

/// The enum that represents overview tab type.
enum OverviewTabType {
  /// All
  all,

  /// Bookmarked
  bookmarked,

  /// Completed
  completed,

  /// Trash
  trash,
}

class OverviewTabView extends StatefulWidget {
  const OverviewTabView({Key? key}) : super(key: key);

  @override
  _OverviewTabViewState createState() => _OverviewTabViewState();
}

class _OverviewTabViewState extends State<OverviewTabView> {
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
  }

  Widget _tabTitle(final String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionWidth(0.5),
      ),
      child: Tab(text: title),
    );
  }

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
            labelStyle: const TextStyle(fontSize: 10.0),
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
            tabs: [
              _tabTitle('All'),
              _tabTitle('Bookmarked'),
              _tabTitle('Completed'),
              _tabTitle('Trash'),
            ],
          ),
          body: const TabBarView(
            children: [
              OverviewView(overviewTabType: OverviewTabType.all),
              OverviewView(overviewTabType: OverviewTabType.bookmarked),
              OverviewView(overviewTabType: OverviewTabType.completed),
              OverviewView(overviewTabType: OverviewTabType.trash),
            ],
          ),
        ),
      );
}
