// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/component/dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/http/api_adapter.dart';
import 'package:flutter/material.dart';

AwesomeDialog? _dialog;
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
var _rawPassword = '';

Future<T?> showAuthDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
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
                pressEvent: () async {
                  if (_usernameController.text.isEmpty) {
                    showAwesomeDialog(
                      context: context,
                      title: 'Input Error',
                      content: 'The username or email address is required.',
                      dialogType: DialogType.WARNING,
                    );
                    return;
                  }

                  if (_rawPassword.isEmpty) {
                    showAwesomeDialog(
                      context: context,
                      title: 'Input Error',
                      content: 'The password is required.',
                      dialogType: DialogType.WARNING,
                    );
                    return;
                  }

                  final authenticated =
                      await ApiAdapter.of(type: ApiAdapterType.login).execute(
                    context: context,
                    params: {
                      'username': _usernameController.text,
                      'password': _rawPassword,
                    },
                  );

                  if (authenticated) {
                    await _dialog!.dismiss();
                  }
                },
                text: 'Login',
                color: Theme.of(context).colorScheme.secondary,
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
