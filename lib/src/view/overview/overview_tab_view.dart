// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
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

class OverviewTabView extends StatelessWidget {
  const OverviewTabView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 4,
        labelFontSize: 11.0,
        unselectedLabelFontSize: 10.0,
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'Bookmarked'),
          Tab(text: 'Completed'),
          Tab(text: 'Trash'),
        ],
        body: [
          OverviewView(overviewTabType: OverviewTabType.all),
          OverviewView(overviewTabType: OverviewTabType.bookmarked),
          OverviewView(overviewTabType: OverviewTabType.completed),
          OverviewView(overviewTabType: OverviewTabType.trash),
        ],
      );
}
