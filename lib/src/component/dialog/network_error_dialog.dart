// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

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
              const Center(
                child: Text(
                  'Network Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  'Could not detect a valid network. Please check the network environment and the network settings of the device.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              AnimatedButton(
                isFixedHeight: false,
                text: 'Open Network Settings',
                color: Theme.of(context).colorScheme.secondaryVariant,
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
