// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/view/tips/tips_and_notes_tab_type.dart';
import 'package:duo_tracker/src/view/tips/tips_and_notes_view.dart';
import 'package:flutter/material.dart';

class TipsAndNotesTabView extends StatelessWidget {
  const TipsAndNotesTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 3,
        labelFontSize: 12.0,
        unselectedLabelFontSize: 11.0,
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'Bookmarked'),
          Tab(text: 'Trash'),
        ],
        body: [
          TipsAndNotesView(tipsAndNotesTabType: TipsAndNotesTabType.all),
          TipsAndNotesView(tipsAndNotesTabType: TipsAndNotesTabType.bookmarked),
          TipsAndNotesView(tipsAndNotesTabType: TipsAndNotesTabType.trash),
        ],
      );
}
