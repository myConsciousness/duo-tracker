// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonDialogTitle extends StatelessWidget {
  const CommonDialogTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  /// The title
  final String title;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}