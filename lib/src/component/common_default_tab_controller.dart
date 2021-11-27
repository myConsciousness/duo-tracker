// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class CommonDefaultTabController extends StatelessWidget {
  final int length;
  final double labelFontSize;
  final double unselectedLabelFontSize;
  final List<Widget> tabs;
  final List<Widget> body;

  const CommonDefaultTabController({
    Key? key,
    required this.length,
    required this.labelFontSize,
    required this.unselectedLabelFontSize,
    required this.tabs,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: length,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            isScrollable: false,
            unselectedLabelColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            unselectedLabelStyle: TextStyle(fontSize: unselectedLabelFontSize),
            labelColor: Theme.of(context).colorScheme.secondary,
            labelStyle: TextStyle(fontSize: labelFontSize),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorWeight: 2.0,
            indicator: DotIndicator(
              color: Theme.of(context).colorScheme.secondary,
              distanceFromCenter: 16,
              radius: 3,
              paintingStyle: PaintingStyle.fill,
            ),
            tabs: tabs,
          ),
          body: TabBarView(children: body),
        ),
      );
}
