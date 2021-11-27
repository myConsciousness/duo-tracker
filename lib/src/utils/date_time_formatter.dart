// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:duo_tracker/src/const/date_format_pattern.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

class DateTimeFormatter {
  /// The datetime format
  DateFormat? _dateFormat;

  Future<String> execute({
    required DateTime dateTime,
    bool onlyDate = false,
  }) async {
    if (_dateFormat == null) {
      await _refresh(onlyDate: onlyDate);
    }

    return _dateFormat!.format(dateTime);
  }

  Future<void> _refresh({
    bool onlyDate = false,
  }) async {
    final dateFormatCode = await CommonSharedPreferencesKey.dateFormat.getInt();
    final dateFormat = DateFormatPatternExt.toEnum(code: dateFormatCode);
    _dateFormat = DateFormat(dateFormat.pattern + (onlyDate ? '' : ' HH:mm'));
  }
}
