// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:duo_tracker/src/admob/banner_ad_list.dart';
import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/add_new_folder_button.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_card_header_text.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/dialog/confirm_dialog.dart';
import 'package:duo_tracker/src/component/dialog/edit_folder_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/model/folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/folder_item_service.dart';
import 'package:duo_tracker/src/repository/service/folder_service.dart';
import 'package:duo_tracker/src/utils/date_time_formatter.dart';
import 'package:duo_tracker/src/view/folder/folder_items_view.dart';
import 'package:duo_tracker/src/view/folder/folder_type.dart';

class FolderView extends StatefulWidget {
  const FolderView({
    Key? key,
    required this.folderType,
  }) : super(key: key);

  /// The folder type
  final FolderType folderType;

  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  /// The banner ad list
  final _bannerAdList = BannerAdList.newInstance();

  /// The date time formatter
  final _dateTimeFormatter = DateTimeFormatter();

  /// The folder item service
  final _folderItemService = FolderItemService.getInstance();

  /// The folder service
  final _folderService = FolderService.getInstance();

  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

  @override
  void dispose() {
    _bannerAdList.dispose();
    super.dispose();
  }

  Future<void> _sortCards({
    required List<Folder> folders,
    required int oldIndex,
    required int newIndex,
  }) async {
    folders.insert(
      oldIndex < newIndex ? newIndex - 1 : newIndex,
      folders.removeAt(oldIndex),
    );

    // Update all sort orders
    await _folderService.replaceSortOrdersByIds(
      folders: folders,
    );
  }

  Widget _buildFolderCard({
    required Folder folder,
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

  IconData get _folderIcon {
    switch (widget.folderType) {
      case FolderType.none:
        throw UnimplementedError();
      case FolderType.word:
        return Icons.text_fields;
      case FolderType.voice:
        return Icons.music_note;
    }
  }

  Widget _buildFolderCardContent({
    required Folder folder,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: _folderItemService.countByFolderIdAndUserId(
                  folderId: folder.id,
                  userId: folder.userId,
                ),
                builder:
                    (BuildContext context, AsyncSnapshot itemCountSnapshot) {
                  if (!itemCountSnapshot.hasData) {
                    return const Loading();
                  }

                  return CommonCardHeaderText(
                    subtitle: 'Folder Items',
                    title: _numericTextFormat.format(itemCountSnapshot.data),
                  );
                },
              ),
              FutureBuilder(
                future: _dateTimeFormatter.execute(dateTime: folder.createdAt),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Loading();
                  }

                  return CommonCardHeaderText(
                    subtitle: 'Created At',
                    title: snapshot.data,
                  );
                },
              ),
              FutureBuilder(
                future: _dateTimeFormatter.execute(dateTime: folder.createdAt),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Loading();
                  }

                  return CommonCardHeaderText(
                    subtitle: 'Updated At',
                    title: snapshot.data,
                  );
                },
              ),
            ],
          ),
          const CommonDivider(),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(
                    _folderIcon,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(folder.name),
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
                        builder: (_) => FolderItemsView(
                          folderType: widget.folderType,
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
                      await _folderService.delete(folder);
                      await _folderItemService.deleteByFolderId(
                        folderId: folder.id,
                      );

                      InfoSnackbar.from(context: context).show(
                        content: 'The folder has been deleted.',
                      );

                      super.setState(() {});
                    },
                  );
                },
              ),
            ],
          ),
        ],
      );

  Future<List<Folder>> _fetchDataSource() async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();

    return await _folderService
        .findByFolderTypeAndUserIdAndFromLanguageAndLearningLanguage(
      folderType: widget.folderType,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );
  }

  Widget _buildFolderListView({
    required List<Folder> folders,
  }) =>
      RefreshIndicator(
        onRefresh: () async {
          super.setState(() {});
        },
        child: ReorderableListView.builder(
          itemCount: folders.length,
          onReorder: (oldIndex, newIndex) async => await _sortCards(
            folders: folders,
            oldIndex: oldIndex,
            newIndex: newIndex,
          ),
          itemBuilder: (_, index) => Column(
            key: Key('${folders[index].sortOrder}'),
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

                  return BannerAdUtils.createBannerAdWidget(
                    _bannerAdList.loadNewBanner(),
                  );
                },
              ),
              _buildFolderCard(
                folder: folders[index],
              ),
            ],
          ),
        ),
      );

  String get _appBarTitle {
    switch (widget.folderType) {
      case FolderType.none:
        throw UnimplementedError();
      case FolderType.word:
        return 'Learned Word Folders';
      case FolderType.voice:
        return 'Playlist Folders';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(title: _appBarTitle),
          actions: [
            IconButton(
              tooltip: 'Add Folder',
              icon: const Icon(Icons.add),
              onPressed: () async {
                await showEditFolderDialog(
                  context: context,
                  folderType: widget.folderType,
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

              final List<Folder> folders = snapshot.data;

              if (folders.isEmpty) {
                return AddNewFolderButton(
                  onPressedCreate: () async {
                    await showEditFolderDialog(
                      context: context,
                      folderType: widget.folderType,
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
