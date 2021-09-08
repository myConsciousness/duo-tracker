// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/view/overview_tab_view.dart';
import 'package:flutter/material.dart';

class Duovoc extends StatefulWidget {
  Duovoc({Key? key}) : super(key: key);

  @override
  _DuovocState createState() => _DuovocState();
}

class _DuovocState extends State<Duovoc> {
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
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        home: OverviewTabView(),
      );
}
