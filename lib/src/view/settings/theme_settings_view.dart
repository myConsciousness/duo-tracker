// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingsView extends StatefulWidget {
  const ThemeSettingsView({Key? key}) : super(key: key);

  @override
  _ThemeSettingsViewState createState() => _ThemeSettingsViewState();
}

class _ThemeSettingsViewState extends State<ThemeSettingsView> {
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
  Widget build(BuildContext context) {
    final ThemeModeProvider themeModeProvider = Provider.of(context);
    return Scaffold(
      body: SafeArea(
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
                        icon: const Icon(Icons.dark_mode),
                        title: 'Use Dark Mode',
                        subtitle:
                            'Switch the theme of app to dark mode. Dark mode consumes less power and is less stressful on your eyes.',
                        onTap: () async {
                          final applyDarkTheme =
                              await CommonSharedPreferencesKey.applyDarkTheme
                                  .getBool();
                          await themeModeProvider.notify(
                              appliedDarkTheme: !applyDarkTheme);
                          super.setState(() {});
                        }),
                  ),
                  Switch(
                    value: themeModeProvider.appliedDarkTheme,
                    onChanged: (value) async {
                      await themeModeProvider.notify(appliedDarkTheme: value);
                      super.setState(() {});
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
