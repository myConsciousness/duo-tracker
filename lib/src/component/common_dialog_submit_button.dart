// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

class CommonDialogSubmitButton extends StatelessWidget {
  const CommonDialogSubmitButton({
    Key? key,
    required this.title,
    required this.pressEvent,
  }) : super(key: key);

  /// The title
  final String title;

  /// The on press event
  final Function pressEvent;

  @override
  Widget build(BuildContext context) => AnimatedButton(
        isFixedHeight: false,
        text: title,
        color: Theme.of(context).colorScheme.secondaryVariant,
        pressEvent: pressEvent,
      );
}
