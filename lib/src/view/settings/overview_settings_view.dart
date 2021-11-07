// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';

class OverviewSettingsView extends StatefulWidget {
  const OverviewSettingsView({Key? key}) : super(key: key);

  @override
  _OverviewSettingsViewState createState() => _OverviewSettingsViewState();
}

class _OverviewSettingsViewState extends State<OverviewSettingsView> {
  /// The use auto aync
  bool _useAutoAync = true;

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
    _asyncInitState();
  }

  Future<void> _asyncInitState() async {
    _useAutoAync = await CommonSharedPreferencesKey.overviewUseAutoSync.getBool(
      defaultValue: true,
    );
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
                      icon: const Icon(Icons.sync_alt),
                      title: 'Use Auto Sync',
                    ),
                  ),
                  Switch(
                    value: _useAutoAync,
                    onChanged: (value) async {
                      await CommonSharedPreferencesKey.overviewUseAutoSync
                          .setBool(value);

                      super.setState(() {
                        _useAutoAync = value;
                      });
                    },
                  ),
                  Expanded(
                    child: _createListTile(
                      icon: const Icon(Icons.sync_alt),
                      title: 'Auto Sync Interval',
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) async {
                      super.setState(() {});
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );
}
