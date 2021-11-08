// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum represents schedule cycle unit.
enum ScheduleCycleUnit {
  /// The day
  day,

  /// The hour
  hour,
}

extension ScheduleCycleUnitExt on ScheduleCycleUnit {
  int get code {
    switch (this) {
      case ScheduleCycleUnit.day:
        return 0;
      case ScheduleCycleUnit.hour:
        return 1;
    }
  }

  static ScheduleCycleUnit toEnum({
    required int code,
  }) {
    for (final scheduleUnit in ScheduleCycleUnit.values) {
      if (scheduleUnit.code == code) {
        return scheduleUnit;
      }
    }

    return ScheduleCycleUnit.day;
  }
}
