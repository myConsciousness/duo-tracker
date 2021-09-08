// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/utils/size_config.dart';
import 'package:duovoc/src/view/overview/overview_tab_view.dart';
import 'package:duovoc/src/view/settings/settings_view.dart';
import 'package:duovoc/src/view/user/user_account_view.dart';
import 'package:flutter/material.dart';

class DuovocHomeView extends StatefulWidget {
  DuovocHomeView({Key? key}) : super(key: key);

  @override
  _DuovocHomeViewState createState() => _DuovocHomeViewState();
}

class _DuovocHomeViewState extends State<DuovocHomeView> {
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
              Tab(icon: Icon(Icons.list_alt)),
              Tab(icon: Icon(Icons.bar_chart)),
              Tab(icon: Icon(Icons.account_circle)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          body: TabBarView(
            children: [
              OverviewTabView(),
              OverviewTabView(),
              UserAccountView(),
              SettingsView(),
            ],
          ),
        ),
      );

  double getProportionHeight(double inputHeight) {
    final screenHeight = SizeConfig.screenHeight;
    return (inputHeight / 812.0) * screenHeight;
  }

  double getProportionWidth(double inputWidth) {
    final screenWidth = SizeConfig.screenWidth;
    return (inputWidth / 375.0) * screenWidth;
  }
}
