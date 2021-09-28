// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class WidgetToImage extends StatelessWidget {
  /// The builder
  final Function(GlobalKey key) builder;

  const WidgetToImage({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();
    return RepaintBoundary(
      key: widgetKey,
      child: builder(widgetKey),
    );
  }
}
