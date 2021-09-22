// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/dialog/common_awesome_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  await showCommonAwesomeDialog(
    context: context,
    dialogType: DialogType.ERROR,
    title: title,
    content: content,
  );
}
