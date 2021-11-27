// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double opacity;
  final bool bold;
  final Color? color;

  const CommonText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.opacity = 1.0,
    this.bold = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: _buildColor(context: context),
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      );

  Color? _buildColor({
    required BuildContext context,
  }) {
    if (color != null) {
      return color!.withOpacity(opacity);
    }

    return Theme.of(context).colorScheme.onSurface.withOpacity(opacity);
  }
}
