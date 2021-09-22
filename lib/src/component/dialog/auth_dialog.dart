// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:flutter/material.dart';

AwesomeDialog? _dialog;
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
String _rawPassword = '';

bool _authenticating = false;

Future<T?> showAuthDialog<T>({
  required BuildContext context,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.SUCCES,
    dismissOnTouchOutside: false,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: Container(
      padding: const EdgeInsets.all(13),
      child: Center(
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Center(
                child: Text(
                  'Authenticate Duolingo Account',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextField(
                controller: _usernameController,
                hintText: 'Username or Email (required)',
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onChanged: (text) {
                  _usernameController.text = text;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextField(
                controller: _passwordController,
                hintText: 'Password (required)',
                maskText: true,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onChanged: (text) {
                  _rawPassword = text;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              AnimatedButton(
                isFixedHeight: false,
                text: 'Login',
                color: Theme.of(context).colorScheme.secondary,
                pressEvent: () async {
                  if (_authenticating) {
                    // Prevents multiple presses.
                    return;
                  }

                  _authenticating = true;

                  if (_usernameController.text.isEmpty) {
                    showInputErrorDialog(
                      context: context,
                      content: 'The username or email address is required.',
                    );

                    _authenticating = false;
                    return;
                  }

                  if (_rawPassword.isEmpty) {
                    showInputErrorDialog(
                      context: context,
                      content: 'The password is required.',
                    );

                    _authenticating = false;
                    return;
                  }

                  if (!await DuolingoApiUtils.authenticateAccount(
                    context: context,
                    username: _usernameController.text,
                    password: _rawPassword,
                  )) {
                    _authenticating = false;
                    return;
                  }

                  await _dialog!.dismiss();
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  await _dialog!.show();
}
