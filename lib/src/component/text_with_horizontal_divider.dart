// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

class TextWithHorizontalDivider extends StatelessWidget {
  /// The text value
  final String value;

  /// The font size
  final double? fontSize;

  /// The text color
  final Color? textColor;

  /// The font weight
  final FontWeight? fontWeight;

  const TextWithHorizontalDivider({
    Key? key,
    required this.value,
    this.fontSize,
    this.textColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          _buildDivider(
            context: context,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: _getTextFontSize(),
              color: _getTextColor(context: context),
              fontWeight: _getFontWeight(),
            ),
          ),
          _buildDivider(
            context: context,
          ),
        ],
      );

  Widget _buildDivider({
    required BuildContext context,
  }) =>
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            color: Theme.of(context).colorScheme.onSurface,
            height: 36,
          ),
        ),
      );

  double? _getTextFontSize() {
    if (fontSize != null) {
      return fontSize;
    }

    return 13;
  }

  Color? _getTextColor({
    required BuildContext context,
  }) {
    if (textColor != null) {
      return textColor;
    }

    return Theme.of(context).colorScheme.onSurface;
  }

  FontWeight? _getFontWeight() {
    if (fontWeight != null) {
      return fontWeight;
    }

    return FontWeight.normal;
  }
}
