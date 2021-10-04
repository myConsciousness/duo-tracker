// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class LearnedWordFolderView extends StatefulWidget {
  const LearnedWordFolderView({Key? key}) : super(key: key);

  @override
  _LearnedWordFolderViewState createState() => _LearnedWordFolderViewState();
}

class _LearnedWordFolderViewState extends State<LearnedWordFolderView> {
  /// The app bar subtitle
  String _appBarSubTitle = 'N/A';

  @override
  void initState() {
    super.initState();
    _buildAppBarSubTitle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSearchBar() => Container(
        margin: const EdgeInsets.fromLTRB(45, 0, 45, 0),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search Word',
            filled: true,
            fillColor:
                Theme.of(context).colorScheme.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          onChanged: (searchWord) async {},
          onSubmitted: (_) async {},
        ),
      );

  Future<void> _buildAppBarSubTitle() async {
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();
    final fromLanguageName =
        LanguageConverter.toName(languageCode: fromLanguage);
    final learningLanguageName =
        LanguageConverter.toName(languageCode: learningLanguage);

    super.setState(() {
      _appBarSubTitle = '$fromLanguageName → $learningLanguageName';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: const SpeedDial(
          renderOverlay: true,
          switchLabelPosition: true,
          buttonSize: 50,
          childrenButtonSize: 50,
          tooltip: 'Show Actions',
          animatedIcon: AnimatedIcons.menu_close,
          children: [],
        ),
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Learned Words Folder',
            subTitle: _appBarSubTitle,
          ),
          body: Container(),
        ),
      );
}
