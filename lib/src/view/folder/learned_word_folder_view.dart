// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/dialog/confirm_dialog.dart';
import 'package:duo_tracker/src/component/dialog/create_new_folder_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_item_service.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/folder/learned_word_folder_items_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  /// The learned word folder item service
  final _learnedWordFolderItemService =
      LearnedWordFolderItemService.getInstance();

  /// The datetime format
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

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
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder(
                                future: _learnedWordFolderItemService
                                    .countByFolderIdAndUserIdAndFromLanguageAndLearningLanguage(
                                  folderId: folder.id,
                                  userId: folder.userId,
                                  fromLanguage: folder.fromLanguage,
                                  learningLanguage: folder.learningLanguage,
                                ),
                                builder: (BuildContext context,
                                    AsyncSnapshot itemCountSnapshot) {
                                  if (!itemCountSnapshot.hasData) {
                                    return const Loading();
                                  }

                                  return _buildCardHeaderText(
                                    title: _numericTextFormat
                                        .format(itemCountSnapshot.data),
                                    subTitle: 'Folder Items',
                                  );
                                },
                              ),
                              _buildCardHeaderText(
                                title: _datetimeFormat.format(folder.createdAt),
                                subTitle: 'Created At',
                              ),
                              _buildCardHeaderText(
                                title: _datetimeFormat.format(folder.updatedAt),
                                subTitle: 'Updated At',
                              ),
                            ],
                          ),
                          const CommonDivider(),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.folder_open,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  title: Text(folder.name),
                                  subtitle: Text(folder.remarks),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            LearnedWordFolderItemsView(
                                          folderId: folder.id,
                                          folderName: folder.name,
                                        ),
                                      ),
                                    ).then((value) => super.setState(() {}));
                                  },
                                ),
                              ),
                              IconButton(
                                tooltip: 'Delete Folder',
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await showConfirmDialog(
                                    context: context,
                                    title: 'Delete Folder',
                                    content:
                                        'Are you sure you want to delete the folder "${folder.name}"?',
                                    onPressedOk: () async {
                                      await _learnedWordFolderService
                                          .delete(folder);
                                      await _learnedWordFolderItemService
                                          .deleteByFolderId(
                                              folderId: folder.id);

                                      super.setState(() {});
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );

  Widget _buildCardHeaderText({
    required String title,
    required String subTitle,
  }) =>
      Column(
        children: [
          _buildTextSecondaryColor(
            text: subTitle,
            fontSize: 12,
          ),
          _buildText(
            text: title,
            fontSize: 14,
          ),
        ],
      );

  Text _buildText({
    required String text,
    required double fontSize,
    double opacity = 1.0,
    bool boldText = false,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(opacity),
          fontSize: fontSize,
          fontWeight: boldText ? FontWeight.bold : FontWeight.normal,
        ),
      );

  Text _buildTextSecondaryColor({
    required String text,
    required double fontSize,
    double opacity = 1.0,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withOpacity(opacity),
          fontSize: fontSize,
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
