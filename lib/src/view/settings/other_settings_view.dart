// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/view/settings/overview_settings_view.dart';
import 'package:flutter/material.dart';

class OtherSettingsView extends StatefulWidget {
  const OtherSettingsView({Key? key}) : super(key: key);

  @override
  _OtherSettingsViewState createState() => _OtherSettingsViewState();
}

class _OtherSettingsViewState extends State<OtherSettingsView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _createListTile({
    required Icon icon,
    required String title,
    String subtitle = '',
    GestureTapCallback? onTap,
  }) =>
      ListTile(
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

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: _createListTile(
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
