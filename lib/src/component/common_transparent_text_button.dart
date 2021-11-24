// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonTransparentTextButton extends StatelessWidget {
  const CommonTransparentTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  /// The on pressed event
  final Function() onPressed;

  /// The title
  final String title;

  @override
  Widget build(BuildContext context) => TextButton(
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        onPressed: onPressed,
      );
}
