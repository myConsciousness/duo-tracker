// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_app_bar_title.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/common_tappable_list_title.dart';
import 'package:duo_tracker/src/view/settings/overview_settings_view.dart';

class OtherSettingsView extends StatefulWidget {
  const OtherSettingsView({Key? key}) : super(key: key);

  @override
  _OtherSettingsViewState createState() => _OtherSettingsViewState();
}

class _OtherSettingsViewState extends State<OtherSettingsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: const CommonAppBarTitle(title: 'Settings'),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTappableListTile(
                      icon: const Icon(Icons.settings),
                      title: 'Open Overview Settings',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OverviewSettingsView(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
