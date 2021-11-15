// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_dialog_content.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:flutter/material.dart';

AwesomeDialog? _dialog;

Future<void> showCommonAwesomeDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogType dialogType,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: dialogType,
    body: Padding(
      padding: const EdgeInsets.all(13),
      child: Center(
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              CommonDialogTitle(title: title),
              const SizedBox(
                height: 30,
              ),
              CommonDialogContent(content: content),
              const SizedBox(
                height: 25,
              ),
              CommonDialogSubmitButton(
                title: 'OK',
                pressEvent: () async {
                  await _dialog!.dismiss();
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  _dialog!.show();
}
