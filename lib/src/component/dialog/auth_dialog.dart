// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

AwesomeDialog? _dialog;
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
String _rawPassword = '';

late bool _authenticating;
late bool _authenticated;

Future<bool> showAuthDialog({
  required BuildContext context,
  bool dismissOnTouchOutside = false,
  bool enableNavigatorPop = true,
}) async {
  _authenticating = false;
  _authenticated = false;

  _usernameController.clear();
  _passwordController.clear();
  _rawPassword = '';

  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.SUCCES,
    dismissOnTouchOutside: dismissOnTouchOutside,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: WillPopScope(
      onWillPop: () async => enableNavigatorPop,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const CommonDialogTitle(title: 'Sign in with Duolingo'),
                const SizedBox(
                  height: 20,
                ),
                CommonTextField(
                  controller: _usernameController,
                  hintText: 'Username or Email',
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
                  hintText: 'Password',
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
                CommonDialogSubmitButton(
                  title: 'Sign in',
                  pressEvent: () async {
                    if (_authenticating) {
                      // Prevents multiple presses.
                      return;
                    }

                    _authenticating = true;

                    if (!await _checkInput(context: context)) {
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

                    _authenticated = true;

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
    ),
  );

  await _dialog!.show();

  return _authenticated;
}

Future<bool> _checkInput({
  required BuildContext context,
}) async {
  if (_usernameController.text.isEmpty) {
    showInputErrorDialog(
      context: context,
      content: 'The username or email address is required.',
    );

    return false;
  }

  final currentUsername = await CommonSharedPreferencesKey.username.getString();

  if (_usernameController.text == currentUsername) {
    showInputErrorDialog(
      context: context,
      content: 'This user is already logged in.',
    );

    return false;
  }

  if (_rawPassword.isEmpty) {
    showInputErrorDialog(
      context: context,
      content: 'The password is required.',
    );

    return false;
  }

  return true;
}
