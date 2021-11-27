// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

abstract class Adapter {
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
  });
}
