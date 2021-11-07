// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum represents schedule unit.
enum ScheduleUnit {
  /// The day
  day,

  /// The month
  month,
}

extension ScheduleUnitExt on ScheduleUnit {
  int get code {
    switch (this) {
      case ScheduleUnit.day:
        return 0;
      case ScheduleUnit.month:
        return 1;
    }
  }

  ScheduleUnit toEnum({
    required int code,
  }) {
    for (final scheduleUnit in ScheduleUnit.values) {
      if (scheduleUnit.code == code) {
        return scheduleUnit;
      }
    }

    return ScheduleUnit.day;
  }
}
