// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/chart/tracker_column_chart.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/service/chart_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  /// The chart service
  final _chartService = ChartService.getInstance();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: _chartService.computeLowProficiencySKillLimit10(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                }

                return TrackerColumnChart(
                  chartTitle: ChartTitle(text: 'Low Proficiency Skill'),
                  chartDataSources: snapshot.data,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    canShowMarker: true,
                    header: 'Proficiency',
                    format: 'point.x : point.y',
                  ),
                  seriesName: 'SKill Name',
                );
              },
            ),
          ),
        ),
      );
}
