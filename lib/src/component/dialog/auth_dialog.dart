// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/component/dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/warn_snack_bar.dart';
import 'package:duo_tracker/src/http/api_adapter.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:flutter/material.dart';

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
}) =>
    Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      DialogRoute<T>(
        context: context,
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: const Text('Authenticate Duolingo Account'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
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
                    ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        if (_usernameController.text.isEmpty) {
                          showAwesomeDialog(
                            context: context,
                            title: 'Input Error',
                            content:
                                'The username or email address is required.',
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

                        await ApiAdapter.of(type: ApiAdapterType.login).execute(
                          context: context,
                          params: {
                            'username': _usernameController.text,
                            'password': _rawPassword,
                          },
                          fromDialog: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        settings: routeSettings,
        themes: InheritedTheme.capture(
          from: context,
          to: Navigator.of(
            context,
            rootNavigator: useRootNavigator,
          ).context,
        ),
      ),
    );
