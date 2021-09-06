// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/component/common_text_field.dart';
import 'package:duovoc/src/component/snackbar/warn_snack_bar.dart';
import 'package:duovoc/src/http/api_adapter.dart';
import 'package:duovoc/src/http/api_response.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

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
        builder: (_) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                title: const Text('Authenticate Duolingo Account'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      CommonTextField(
                        controller: _usernameController,
                        hintText: 'Username or Email (required)',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).accentColor,
                        ),
                        onChanged: (text) {
                          _usernameController.text = text;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CommonTextField(
                        controller: _passwordController,
                        hintText: 'Password (required)',
                        maskText: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).accentColor,
                        ),
                        onChanged: (text) {
                          _rawPassword = text;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          if (_usernameController.text.isEmpty) {
                            WarnSnackbar.from(context: context).show(
                                content:
                                    'The username or email address is required.');
                            return;
                          }

                          if (_rawPassword.isEmpty) {
                            WarnSnackbar.from(context: context)
                                .show(content: 'The password is required.');
                            return;
                          }

                          final response =
                              await Adapter.of(type: ApiAdapterType.login)
                                  .execute(
                            params: {
                              'login': '${_usernameController.text}',
                              'password': '$_rawPassword',
                            },
                          );

                          switch (response.errorType) {
                            case ErrorType.none:
                              break;
                            case ErrorType.network:
                              OpenSettings.openNetworkOperatorSetting();
                              break;
                            case ErrorType.username:
                              // TODO: Handle this case.
                              break;
                            case ErrorType.password:
                              // TODO: Handle this case.
                              break;
                            case ErrorType.client:
                              // TODO: Handle this case.
                              break;
                            case ErrorType.server:
                              // TODO: Handle this case.
                              break;
                            case ErrorType.unknown:
                              // TODO: Handle this case.
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
