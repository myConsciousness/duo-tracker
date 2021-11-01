// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonTwoGridsRadioListTile<T> extends StatefulWidget {
  const CommonTwoGridsRadioListTile({
    Key? key,
    this.label,
    required this.dataSource,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  final Function(dynamic value) onChanged;
  final Map<String, T> dataSource;
  final T groupValue;
  final String? label;

  @override
  _CommonTwoGridsRadioListTileState<T> createState() =>
      _CommonTwoGridsRadioListTileState();
}

class _CommonTwoGridsRadioListTileState<T>
    extends State<CommonTwoGridsRadioListTile> {
  @override
  Widget build(BuildContext context) {
    final firstFlexibleRadioListTiles = <Flexible>[];
    final secondFlexibleRadioListTiles = <Flexible>[];

    int count = 1;
    widget.dataSource.forEach(
      (title, value) {
        if (count % 2 == 0) {
          secondFlexibleRadioListTiles.add(
            Flexible(
              child: RadioListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
                value: value,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
            ),
          );
        } else {
          firstFlexibleRadioListTiles.add(
            Flexible(
              child: RadioListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
                value: value,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
            ),
          );
        }

        count++;
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.label != null)
          const SizedBox(
            height: 5,
          ),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: firstFlexibleRadioListTiles,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: secondFlexibleRadioListTiles,
              ),
            ),
          ],
        )
      ],
    );
  }
}
