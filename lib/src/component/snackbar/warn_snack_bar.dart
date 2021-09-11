// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class WarnSnackbar {
  /// Returns the new instance of [WarnSnackbar] based on the [context] passed as an argument.
  WarnSnackbar.from({
    required this.context,
  });

  /// The build context
  final BuildContext context;

  void show({
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: <Widget>[
            const Icon(
              Icons.warning,
              color: Colors.amber,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(content),
          ],
        ),
      ),
    );
  }
}
