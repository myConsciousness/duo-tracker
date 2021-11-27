// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/repository/const/column/chart_column.dart';

class ChartDataSource {
  ChartDataSource.from({
    required this.x,
    required this.y,
    this.text,
    this.pointColor,
  });

  /// Returns the new instance of [ChartDataSource] based on the [map] passed as an argument.
  factory ChartDataSource.fromMap(Map<String, dynamic> map) =>
      ChartDataSource.from(
        x: map[ChartColumn.xValue],
        y: map[ChartColumn.yValue],
        text: '100%',
        pointColor: map.containsKey(ChartColumn.colorR)
            ? Color.fromRGBO(
                map[ChartColumn.colorR],
                map[ChartColumn.colorG],
                map[ChartColumn.colorB],
                map[ChartColumn.colorO],
              )
            : null,
      );

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds x value of the datapoint
  final String x;

  /// Holds y value of the datapoint
  final double y;
}
