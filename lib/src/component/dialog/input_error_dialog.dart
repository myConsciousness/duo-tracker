// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:flutter/material.dart';

void showInputErrorDialog<T>({
  required BuildContext context,
  required String content,
}) {
  showErrorDialog(
    context: context,
    title: 'Input Error',
    content: content,
  );
}
