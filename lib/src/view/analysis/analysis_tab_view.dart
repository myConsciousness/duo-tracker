// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/view/analysis/proficiency_analysis_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnalysisTabView extends StatelessWidget {
  const AnalysisTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 1,
        labelFontSize: 11.0,
        unselectedLabelFontSize: 10.0,
        tabs: [
          Tab(text: 'Proficiency'),
        ],
        body: [
          ProficiencyAnalysisView(),
        ],
      );
}
