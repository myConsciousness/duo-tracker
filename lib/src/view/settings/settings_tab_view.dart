// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/view/settings/about_app_view.dart';
import 'package:duo_tracker/src/view/settings/other_settings_view.dart';
import 'package:duo_tracker/src/view/settings/theme_settings_view.dart';
import 'package:flutter/material.dart';

class SettingsTabView extends StatelessWidget {
  const SettingsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 3,
        labelFontSize: 12.0,
        unselectedLabelFontSize: 11.0,
        tabs: [
          Tab(text: 'About App'),
          Tab(text: 'Theme'),
          Tab(text: 'Others'),
        ],
        body: [
          AboutAppView(),
          ThemeSettingsView(),
          OtherSettingsView(),
        ],
      );
}
