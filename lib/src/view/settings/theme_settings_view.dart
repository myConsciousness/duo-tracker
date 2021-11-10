// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_tappable_list_title.dart';
import 'package:duo_tracker/src/component/dialog/select_date_time_format_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/const/date_format_pattern.dart';
import 'package:duo_tracker/src/provider/theme_mode_provider.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                    child: CommonTappableListTile(
                      icon: const Icon(Icons.dark_mode),
                      title: 'Use Dark Mode',
                      subtitle:
                          'Switch the theme of app to dark mode. Dark mode consumes less power and is less stressful on your eyes.',
                      onTap: () async {
                        final applyDarkTheme = await CommonSharedPreferencesKey
                            .applyDarkTheme
                            .getBool();
                        await themeModeProvider.notify(
                            appliedDarkTheme: !applyDarkTheme);
                        super.setState(() {});
                      },
                    ),
                  ),
                  Switch(
                    value: themeModeProvider.appliedDarkTheme,
                    onChanged: (value) async {
                      await themeModeProvider.notify(appliedDarkTheme: value);
                      super.setState(() {});
                    },
                  ),
                ],
              ),
              const CommonDivider(),
              FutureBuilder(
                future: _getCurrentDateFormatPattern(),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Loading();
                  }

                  return CommonTappableListTile(
                    icon: const Icon(FontAwesomeIcons.clock),
                    title: 'Date Format',
                    subtitle: snapshot.data,
                    onTap: () async {
                      await showSelectDateTimeFormatDialog(
                        context: context,
                        onSubmitted: () {
                          super.setState(() {});
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getCurrentDateFormatPattern() async {
    final dateFormatCode = await CommonSharedPreferencesKey.dateFormat.getInt();
    return DateFormatPatternExt.toEnum(code: dateFormatCode).pattern;
  }
}
