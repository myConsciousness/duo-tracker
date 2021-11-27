// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

class CommonDialogCancelButton extends StatelessWidget {
  const CommonDialogCancelButton({
    Key? key,
    required this.onPressEvent,
  }) : super(key: key);

  /// The on press event
  final Function onPressEvent;

  @override
  Widget build(BuildContext context) => AnimatedButton(
        isFixedHeight: false,
        text: 'Cancel',
        color: Theme.of(context).colorScheme.error,
        pressEvent: onPressEvent,
      );
}
