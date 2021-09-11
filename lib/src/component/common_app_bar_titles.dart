// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonAppBarTitles extends StatefulWidget {
  const CommonAppBarTitles({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  /// The subtitle
  final String subTitle;

  /// The title
  final String title;

  @override
  _CommonAppBarTitlesState createState() => _CommonAppBarTitlesState();
}

class _CommonAppBarTitlesState extends State<CommonAppBarTitles> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            widget.subTitle,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
}
