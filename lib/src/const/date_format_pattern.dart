// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum reoresents date format pattern.
enum DateFormatPattern {
  /// 2000/12/24
  yyyymmdd,

  /// 2000/24/12
  yyyyddmm,

  /// 24/12/2000
  ddmmyyyy,

  /// 12/24/2020
  mmddyyyy,
}

extension DateFormatPatternExt on DateFormatPattern {
  int get code {
    switch (this) {
      case DateFormatPattern.yyyymmdd:
        return 0;
      case DateFormatPattern.yyyyddmm:
        return 1;
      case DateFormatPattern.ddmmyyyy:
        return 2;
      case DateFormatPattern.mmddyyyy:
        return 3;
    }
  }

  String get pattern {
    switch (this) {
      case DateFormatPattern.yyyymmdd:
        return 'yyyy/MM/dd';
      case DateFormatPattern.yyyyddmm:
        return 'yyyy/dd/MM';
      case DateFormatPattern.ddmmyyyy:
        return 'dd/MM/yyyy';
      case DateFormatPattern.mmddyyyy:
        return 'MM/dd/yyyy';
    }
  }

  static DateFormatPattern toEnum({
    required int code,
  }) {
    for (final dateFormatPattern in DateFormatPattern.values) {
      if (dateFormatPattern.code == code) {
        return dateFormatPattern;
      }
    }

    return DateFormatPattern.yyyymmdd;
  }
}
