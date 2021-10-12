// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';

@Deprecated('Not used yet')
class CommonPasscodeView extends StatefulWidget {
  const CommonPasscodeView({
    Key? key,
    required this.title,
    required this.passwordEnteredCallback,
    required this.cancelCallback,
  }) : super(key: key);

  final CancelCallback cancelCallback;
  final PasswordEnteredCallback passwordEnteredCallback;
  final String title;

  @override
  _CommonPasscodeViewState createState() => _CommonPasscodeViewState();
}

// ignore: deprecated_member_use_from_same_package
class _CommonPasscodeViewState extends State<CommonPasscodeView> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PasscodeScreen(
        title: Text(widget.title),
        passwordDigits: 6,
        passwordEnteredCallback: widget.passwordEnteredCallback,
        cancelCallback: widget.cancelCallback,
        cancelButton: const Text('Cancel'),
        deleteButton: const Text('Delete'),
        shouldTriggerVerification: _verificationNotifier.stream,
      );
}
