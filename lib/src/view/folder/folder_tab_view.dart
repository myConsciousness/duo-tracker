// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/view/folder/folder_view.dart';
import 'package:flutter/material.dart';

class FolderTabView extends StatelessWidget {
  const FolderTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 3,
        labelFontSize: 12.0,
        unselectedLabelFontSize: 11.0,
        tabs: [
          Tab(text: 'Word'),
          Tab(text: 'Voice'),
          Tab(text: 'Tips'),
        ],
        body: [
          FolderView(folderType: FolderType.word),
          FolderView(folderType: FolderType.voice),
          FolderView(folderType: FolderType.tipsAndNotes),
        ],
      );
}
