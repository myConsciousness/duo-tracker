// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/view/overview_view.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
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
            labelStyle: const TextStyle(fontSize: 13.0),
            indicatorColor: Colors.white,
            indicatorWeight: 2.0,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            // labelColor: Colors.white,
            // unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.list_alt)),
              Tab(icon: Icon(Icons.bookmark_added)),
              Tab(icon: Icon(Icons.done)),
              Tab(icon: Icon(Icons.hide_source)),
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
