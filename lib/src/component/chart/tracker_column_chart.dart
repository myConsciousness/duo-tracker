// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/chart_data_source_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TrackerColumnChart extends StatefulWidget {
  const TrackerColumnChart({
    Key? key,
    required this.chartTitle,
    required this.tooltipBehavior,
    required this.chartDataSources,
    required this.seriesName,
  }) : super(key: key);

  /// The chart data sources
  final List<ChartDataSource> chartDataSources;

  /// The chart title
  final ChartTitle chartTitle;

  /// The tooltip behavior
  final TooltipBehavior tooltipBehavior;

  /// The series name
  final String seriesName;

  @override
  _TrackerColumnChartState createState() => _TrackerColumnChartState();
}

class _TrackerColumnChartState extends State<TrackerColumnChart> {
  SfCartesianChart _buildTrackerColumnChart() => SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: widget.chartTitle,
        enableAxisAnimation: true,
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelRotation: 90,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0.0,
          maximum: 1.0,
          numberFormat: NumberFormat.percentPattern(),
          title: AxisTitle(text: 'aaaa'),
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: _buildTracker(),
        tooltipBehavior: widget.tooltipBehavior,
      );

  List<ColumnSeries<ChartDataSource, String>> _buildTracker() =>
      <ColumnSeries<ChartDataSource, String>>[
        ColumnSeries<ChartDataSource, String>(
            dataSource: widget.chartDataSources,
            isTrackVisible: true,
            trackColor: Colors.grey,
            borderRadius: BorderRadius.circular(15),
            xValueMapper: (ChartDataSource dataSource, _) => dataSource.x,
            yValueMapper: (ChartDataSource dataSource, _) => dataSource.y,
            name: widget.seriesName,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            legendIconType: LegendIconType.circle),
      ];

  @override
  Widget build(BuildContext context) => _buildTrackerColumnChart();
}
