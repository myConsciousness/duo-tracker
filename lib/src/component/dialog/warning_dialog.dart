// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/component/dialog/common_awesome_dialog.dart';

Future<void> showWarningDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  await showCommonAwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    title: title,
    content: content,
  );
}
