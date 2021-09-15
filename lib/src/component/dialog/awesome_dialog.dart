// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showAwesomeDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogType dialogType,
}) {
  AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: dialogType,
    title: title,
    desc: content,
    btnOkText: 'OK',
    btnOkColor: Theme.of(context).colorScheme.secondary,
    btnOkOnPress: () {},
  ).show();
}
