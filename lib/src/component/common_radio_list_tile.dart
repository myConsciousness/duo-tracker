// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonRadioListTile<T> extends StatefulWidget {
  final String? label;
  final Map<String, T> dataSource;
  final T groupValue;
  final Function(dynamic value) onChanged;

  CommonRadioListTile({
    Key? key,
    this.label,
    required this.dataSource,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CommonRadioListTileState<T> createState() => _CommonRadioListTileState();
}

class _CommonRadioListTileState<T> extends State<CommonRadioListTile> {
  @override
  Widget build(BuildContext context) {
    final flexibleRadioListTiles = <Flexible>[];

    widget.dataSource.forEach(
      (title, value) {
        flexibleRadioListTiles.add(
          Flexible(
            child: RadioListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                value: value,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged),
          ),
        );
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        if (widget.label != null)
          SizedBox(
            height: 5,
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: flexibleRadioListTiles,
        ),
      ],
    );
  }
}
