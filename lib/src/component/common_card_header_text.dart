// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_text.dart';
import 'package:flutter/material.dart';

class CommonCardHeaderText extends StatelessWidget {
  /// The title
  final String title;

  /// The subtitle
  final String subtitle;

  const CommonCardHeaderText({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Wrap(
            children: [
              CommonText(
                text: subtitle,
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
                bold: true,
              ),
            ],
          ),
          CommonText(
            text: title,
            fontSize: 14,
          ),
        ],
      );
}
