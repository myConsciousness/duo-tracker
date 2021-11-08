// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

class SharedPreferencesUtils {
  static Future<int> getCurrentIntValueOrDefault({
    required CommonSharedPreferencesKey currentKey,
    required CommonSharedPreferencesKey defaultKey,
  }) async {
    final code = await currentKey.getInt();

    if (code > -1) {
      return code;
    }

    return defaultKey.getInt();
  }
}
