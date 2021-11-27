// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

class CommonTappableListTile extends StatelessWidget {
  const CommonTappableListTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle = '',
    this.onTap,
  }) : super(key: key);

  /// The icon
  final Icon icon;

  /// The title
  final String title;

  /// The subtitle
  final String subtitle;

  /// The on tap event
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle.isEmpty
            ? null
            : Text(
                subtitle,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
        onTap: onTap,
      );
}
