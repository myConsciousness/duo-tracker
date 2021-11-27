// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_dialog_cancel_button.dart';
import 'package:duo_tracker/src/component/common_dialog_content.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';

late AwesomeDialog _dialog;

Future<void> showConfirmDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  Function()? onPressedOk,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: DialogType.QUESTION,
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
                  if (onPressedOk != null) {
                    onPressedOk.call();
                  }

                  await _dialog.dismiss();
                },
              ),
              CommonDialogCancelButton(
                onPressEvent: () async => await _dialog.dismiss(),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  _dialog.show();
}
