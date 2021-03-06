// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

class CommonIconButton extends StatefulWidget {
  const CommonIconButton({
    Key? key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;
  final Icon icon;
  final String tooltip;

  @override
  _CommonIconButtonState createState() => _CommonIconButtonState();
}

class _CommonIconButtonState extends State<CommonIconButton> {
  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: widget.tooltip,
        icon: widget.icon,
        onPressed: widget.onPressed,
        color: Theme.of(context).colorScheme.secondary,
      );
}
