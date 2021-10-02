// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/chart_data_source_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadicalBarChart extends StatelessWidget {
  /// The chart title
  final ChartTitle? chartTitle;

  /// The center object
  final Widget centerObject;

  /// The chart data sources
  final List<ChartDataSource> chartDataSources;

  const RadicalBarChart({
    Key? key,
    this.chartTitle,
    required this.centerObject,
    required this.chartDataSources,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCustomizedRadialBarChart();
  }

  SfCircularChart _buildCustomizedRadialBarChart() => SfCircularChart(
        title: chartTitle,
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: _getRadialBarCustomizedSeries(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y%',
        ),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            angle: 0,
            radius: '0%',
            height: '95%',
            width: '95%',
            widget: centerObject,
          ),
        ],
      );

  /// Returns radial bar which need to be customized.
  List<RadialBarSeries<ChartDataSource, String>>
      _getRadialBarCustomizedSeries() =>
          <RadialBarSeries<ChartDataSource, String>>[
            RadialBarSeries<ChartDataSource, String>(
              animationDuration: 0,
              maximumValue: 100,
              gap: '10%',
              radius: '100%',
              dataSource: chartDataSources,
              cornerStyle: CornerStyle.bothCurve,
              innerRadius: '50%',
              xValueMapper: (ChartDataSource data, _) => data.x,
              yValueMapper: (ChartDataSource data, _) => data.y,
              pointRadiusMapper: (ChartDataSource data, _) => data.text,
              legendIconType: LegendIconType.circle,
            ),
          ];
}
