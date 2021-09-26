// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text('Mi amooooooor, siempre te amo muuuuuucho mas!'),
            const Text('Thinking of putting up some statistical graphs here'),
            const Text('but I have not solidified the idea yet!'),
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/icon/mochi.png'),
          ],
        ),
      );
}
