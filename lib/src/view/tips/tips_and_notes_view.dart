// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/view/tips/tips_and_notes_tab_type.dart';
import 'package:flutter/material.dart';

class TipsAndNotesView extends StatefulWidget {
  /// The tips anfd notes tab type
  final TipsAndNotesTabType tipsAndNotesTabType;

  const TipsAndNotesView({
    Key? key,
    required this.tipsAndNotesTabType,
  }) : super(key: key);

  @override
  _TipsAndNotesViewState createState() => _TipsAndNotesViewState();
}

class _TipsAndNotesViewState extends State<TipsAndNotesView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
