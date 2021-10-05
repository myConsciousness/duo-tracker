// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_item_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_item_service.dart';
import 'package:flutter/material.dart';

class LearnedWordFolderItemsView extends StatefulWidget {
  /// The folder code
  final int folderId;

  /// The folder name
  final String folderName;

  const LearnedWordFolderItemsView({
    Key? key,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  @override
  _LearnedWordFolderItemsViewState createState() =>
      _LearnedWordFolderItemsViewState();
}

class _LearnedWordFolderItemsViewState
    extends State<LearnedWordFolderItemsView> {
  /// The learned word folder item service
  final _learnedWordFolderItemService =
      LearnedWordFolderItemService.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Stored Learned Words',
            subTitle: 'Folder: ${widget.folderName}',
          ),
          body: FutureBuilder(
            future: _fetchDataSource(folderId: widget.folderId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<LearnedWordFolderItem> items = snapshot.data;

              if (items.isEmpty) {
                return const Center(
                  child: Text('No Items'),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(item.alias),
                      subtitle: Text(item.remarks),
                      onTap: () {},
                    ),
                  );
                },
              );
            },
          ),
        ),
      );

  Future<List<LearnedWordFolderItem>> _fetchDataSource({
    required int folderId,
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();

    return await _learnedWordFolderItemService
        .findByFolderIdAndUserIdAndFromLanguageAndLearningLanguage(
      folderId: folderId,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );
  }
}
