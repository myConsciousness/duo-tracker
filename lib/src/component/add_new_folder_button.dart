// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class AddNewFolderButton extends StatefulWidget {
  /// The action on pressed create
  final Function()? onPressedCreate;

  const AddNewFolderButton({
    Key? key,
    this.onPressedCreate,
  }) : super(key: key);

  @override
  _AddNewFolderButtonState createState() => _AddNewFolderButtonState();
}

class _AddNewFolderButtonState extends State<AddNewFolderButton> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text('No Folders'),
          ),
          ElevatedButton(
            child: const Text('Add New Folder'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondaryVariant,
              onPrimary: Colors.white,
            ),
            onPressed: widget.onPressedCreate,
          ),
        ],
      );
}
