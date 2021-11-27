// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:open_settings/open_settings.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_dialog_content.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';

AwesomeDialog? _dialog;

Future<void> showNetworkErrorDialog<T>({
  required BuildContext context,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: DialogType.ERROR,
    body: Padding(
      padding: const EdgeInsets.all(13),
      child: Center(
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const CommonDialogTitle(title: 'Network Error'),
              const SizedBox(
                height: 30,
              ),
              const CommonDialogContent(
                content:
                    'Could not detect a valid network. Please check the network environment and the network settings of the device.',
              ),
              const SizedBox(
                height: 25,
              ),
              CommonDialogSubmitButton(
                title: 'Open Network Settings',
                pressEvent: () async {
                  await OpenSettings.openNetworkOperatorSetting();
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
