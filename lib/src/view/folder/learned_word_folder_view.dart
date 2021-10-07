// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/add_new_folder_button.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/dialog/confirm_dialog.dart';
import 'package:duo_tracker/src/component/dialog/create_new_folder_dialog.dart';
import 'package:duo_tracker/src/component/dialog/edit_folder_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_item_service.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/folder/learned_word_folder_items_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class LearnedWordFolderView extends StatefulWidget {
  const LearnedWordFolderView({Key? key}) : super(key: key);

  @override
  _LearnedWordFolderViewState createState() => _LearnedWordFolderViewState();
}

class _LearnedWordFolderViewState extends State<LearnedWordFolderView> {
  /// The app bar subtitle
  String _appBarSubTitle = 'N/A';

  /// The banner ads
  final List<BannerAd> _bannerAds = <BannerAd>[];

  /// The datetime format
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  /// The learned word folder item service
  final _learnedWordFolderItemService =
      LearnedWordFolderItemService.getInstance();

  /// The learned word folder service
  final _learnedWordFolderService = LearnedWordFolderService.getInstance();

  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (final bannerAd in _bannerAds) {
      bannerAd.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _buildAppBarSubTitle();
  }

  BannerAd _loadBannerAd() {
    final BannerAd bannerAd = BannerAdUtils.loadBannerAd();
    _bannerAds.add(bannerAd);
    return bannerAd;
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

  Widget _buildFolderCard({
    required LearnedWordFolder folder,
  }) =>
      Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildFolderCardContent(
            folder: folder,
          ),
        ),
      );

  Widget _buildFolderCardContent({
    required LearnedWordFolder folder,
  }) =>
      Column(
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
                builder:
                    (BuildContext context, AsyncSnapshot itemCountSnapshot) {
                  if (!itemCountSnapshot.hasData) {
                    return const Loading();
                  }

                  return _buildCardHeaderText(
                    title: _numericTextFormat.format(itemCountSnapshot.data),
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
                    Icons.text_fields,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Row(
                    children: [
                      Text(
                        folder.alias.isEmpty ? folder.name : folder.alias,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () async {
                          await showEditFolderDialog(
                            context: context,
                            folderId: folder.id,
                            folderType: FolderType.word,
                          );

                          super.setState(() {});
                        },
                      ),
                    ],
                  ),
                  subtitle: Text(folder.remarks),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LearnedWordFolderItemsView(
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
                      await _learnedWordFolderService.delete(folder);
                      await _learnedWordFolderItemService.deleteByFolderId(
                          folderId: folder.id);

                      super.setState(() {});
                    },
                  );
                },
              ),
            ],
          ),
        ],
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

  Widget _buildFolderListView({
    required List<LearnedWordFolder> folders,
  }) =>
      ListView.builder(
        itemCount: folders.length,
        itemBuilder: (BuildContext context, int index) {
          final folder = folders[index];
          return Column(
            children: [
              FutureBuilder(
                future: BannerAdUtils.canShow(
                  index: index,
                  interval: 3,
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || !snapshot.data) {
                    return Container();
                  }

                  return BannerAdUtils.createBannerAdWidget(_loadBannerAd());
                },
              ),
              _buildFolderCard(
                folder: folder,
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Learned Word Folders',
            subTitle: _appBarSubTitle,
          ),
          actions: [
            IconButton(
              tooltip: 'Add Folder',
              icon: const Icon(Icons.add),
              onPressed: () async {
                await showCreateNewFolderDialog(
                  context: context,
                  folderType: FolderType.word,
                );

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
                return AddNewFolderButton(
                  folderType: FolderType.word,
                  onPressedCreate: () async {
                    await showCreateNewFolderDialog(
                      context: context,
                      folderType: FolderType.word,
                    );

                    super.setState(() {});
                  },
                );
              }

              return _buildFolderListView(
                folders: folders,
              );
            },
          ),
        ),
      );
}
