// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class InfoSnackbar {
  /// Returns the new instance of [InfoSnackbar] based on the [context] passed as an argument.
  InfoSnackbar.from({
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
              Icons.info,
              color: Colors.blue,
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
