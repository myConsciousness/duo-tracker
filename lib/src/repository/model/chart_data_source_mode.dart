// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/chart_column_name.dart';
import 'package:flutter/material.dart';

class ChartDataSource {
  ChartDataSource.from({
    required this.x,
    required this.y,
    required this.text,
    required this.pointColor,
  });

  /// Returns the new instance of [ChartDataSource] based on the [map] passed as an argument.
  factory ChartDataSource.fromMap(Map<String, dynamic> map) =>
      ChartDataSource.from(
        x: map[ChartColumnName.xValue],
        y: map[ChartColumnName.yValue],
        text: '100%',
        pointColor: Color.fromRGBO(
          map[ChartColumnName.colorR],
          map[ChartColumnName.colorG],
          map[ChartColumnName.colorB],
          map[ChartColumnName.colorO],
        ),
      );

  /// Holds point color of the datapoint
  final Color pointColor;

  /// Holds datalabel/text value mapper of the datapoint
  final String text;

  /// Holds x value of the datapoint
  final String x;

  /// Holds y value of the datapoint
  final double y;
}
