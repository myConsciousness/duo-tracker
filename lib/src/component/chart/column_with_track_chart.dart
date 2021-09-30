import 'package:duo_tracker/src/repository/model/chart_data_source_mode.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnWithTrackChart extends StatefulWidget {
  const ColumnWithTrackChart({Key? key}) : super(key: key);

  @override
  _ColumnWithTrackChartState createState() => _ColumnWithTrackChartState();
}

class _ColumnWithTrackChartState extends State<ColumnWithTrackChart> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'point.y marks in point.x');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackerColumnChart();
  }

  /// Get column series with track
  SfCartesianChart _buildTrackerColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Marks of a student'),
      legend: Legend(isVisible: true),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getTracker(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Get column series with tracker
  List<ColumnSeries<ChartDataSource, String>> _getTracker() {
    final List<ChartDataSource> chartData = <ChartDataSource>[
      ChartDataSource.from(
          x: 'Subject 1', y: 71, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 2', y: 84, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 3', y: 48, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 4', y: 80, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 5', y: 76, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 6', y: 76, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 7', y: 76, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 8', y: 76, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 9', y: 76, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 10', y: 76, pointColor: Colors.amber, text: 'text'),
      ChartDataSource.from(
          x: 'Subject 11', y: 76, pointColor: Colors.amber, text: 'text')
    ];

    return <ColumnSeries<ChartDataSource, String>>[
      ColumnSeries<ChartDataSource, String>(
          dataSource: chartData,

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(198, 201, 207, 1),
          borderRadius: BorderRadius.circular(15),
          xValueMapper: (ChartDataSource sales, _) => sales.x,
          yValueMapper: (ChartDataSource sales, _) => sales.y,
          name: 'Marks',
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }
}
