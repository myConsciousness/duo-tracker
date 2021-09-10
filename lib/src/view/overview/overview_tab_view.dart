// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/utils/size_config.dart';
import 'package:duovoc/src/view/overview/overview_view.dart';
import 'package:flutter/material.dart';

/// The enum that represents overview tab type.
enum OverviewTabType {
  /// All
  all,

  /// Bookmarked
  bookmarked,

  /// Completed
  completed,

  /// Hidden
  hidden,
}

class OverviewTabView extends StatefulWidget {
  OverviewTabView({Key? key}) : super(key: key);

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
        horizontal: this.getProportionWidth(0.5),
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
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            unselectedLabelStyle: TextStyle(fontSize: 11.0),
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 12.0),
            indicatorColor: Colors.white,
            indicatorWeight: 2.0,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: this.getProportionWidth(3),
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            tabs: [
              this._tabTitle('All'),
              this._tabTitle('Bookmarked'),
              this._tabTitle('Completed'),
              this._tabTitle('Hidden'),
            ],
          ),
          body: TabBarView(
            children: [
              OverviewView(overviewTabType: OverviewTabType.all),
              OverviewView(overviewTabType: OverviewTabType.bookmarked),
              OverviewView(overviewTabType: OverviewTabType.completed),
              OverviewView(overviewTabType: OverviewTabType.hidden),
            ],
          ),
        ),
      );
}
