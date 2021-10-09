// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog? _dialog;

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
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              AnimatedButton(
                isFixedHeight: false,
                text: 'OK',
                color: Theme.of(context).colorScheme.secondaryVariant,
                pressEvent: () async {
                  if (onPressedOk != null) {
                    onPressedOk.call();
                  }

                  await _dialog!.dismiss();
                },
              ),
              AnimatedButton(
                isFixedHeight: false,
                text: 'Cancel',
                color: Theme.of(context).colorScheme.error,
                pressEvent: () async {
                  await _dialog!.dismiss();
                },
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

  _dialog!.show();
}
