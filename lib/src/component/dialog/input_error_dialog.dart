// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/dialog/warning_dialog.dart';

Future<void> showInputErrorDialog<T>({
  required BuildContext context,
  required String content,
}) async {
  await showWarningDialog(
    context: context,
    title: 'Input Error',
    content: content,
  );
}
