// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

class CommonDialogContent extends StatelessWidget {
  const CommonDialogContent({
    Key? key,
    required this.content,
  }) : super(key: key);

  /// The content
  final String content;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      );
}
