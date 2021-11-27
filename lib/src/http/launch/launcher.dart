// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

abstract class Launcher {
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
  });

  void checkParameterKey({
    required Map<String, String> params,
    required String name,
  }) {
    if (!params.containsKey(name)) {
      throw FlutterError('The parameter key "$name" is required.');
    }
  }
}
