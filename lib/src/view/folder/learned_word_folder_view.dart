// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/dialog/create_new_folder_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_item_service.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/folder/learned_word_folder_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LearnedWordFolderView extends StatefulWidget {
  const LearnedWordFolderView({Key? key}) : super(key: key);

  @override
  _LearnedWordFolderViewState createState() => _LearnedWordFolderViewState();
}

class _LearnedWordFolderViewState extends State<LearnedWordFolderView> {
  /// The app bar subtitle
  String _appBarSubTitle = 'N/A';

  /// The learned word folder service
  final _learnedWordFolderService = LearnedWordFolderService.getInstance();

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

  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) =>
      SpeedDialChild(
        child: Icon(
          icon,
          size: 19,
        ),
        label: label,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Learned Word Folder',
            subTitle: _appBarSubTitle,
          ),
          actions: [
            IconButton(
              tooltip: 'Add Folder',
              icon: const Icon(Icons.add),
              onPressed: () async {
                await showCreateNewFolderDialog(context: context);
                super.setState(() {});
              },
            ),
          ],
          body: FutureBuilder(
            future: _fetchDataSource(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<LearnedWordFolder> folders = snapshot.data;

              if (folders.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text('No Folders'),
                    ),
                    ElevatedButton(
                      child: const Text('Add New Folder'),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondaryVariant,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () async {
                        await showCreateNewFolderDialog(context: context);
                        super.setState(() {});
                      },
                    ),
                  ],
                );
              }

              return ListView.builder(
                itemCount: folders.length,
                itemBuilder: (BuildContext context, int index) {
                  final folder = folders[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(folder.name),
                      subtitle: Text(folder.remarks),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LearnedWordFolderItemsView(
                              folderCode: folder.id,
                              folderName: folder.name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      );

  Future<List<LearnedWordFolder>> _fetchDataSource() async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();

    return await _learnedWordFolderService
        .findByUserIdAndFromLanguageAndLearningLanguage(
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );
  }
}
