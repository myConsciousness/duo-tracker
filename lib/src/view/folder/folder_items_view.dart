// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_learned_word_card.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/folder_item_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/folder_item_service.dart';
import 'package:duo_tracker/src/utils/audio_player_utils.dart';
import 'package:flutter/material.dart';

class FolderItemsView extends StatefulWidget {
  const FolderItemsView({
    Key? key,
    required this.folderType,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  /// The folder code
  final int folderId;

  /// The folder name
  final String folderName;

  /// The folder type
  final FolderType folderType;

  @override
  _FolderItemsViewState createState() => _FolderItemsViewState();
}

class _FolderItemsViewState extends State<FolderItemsView> {
  late List<FolderItem> _folderItems;

  /// The learned word folder item service
  final _learnedWordFolderItemService = FolderItemService.getInstance();

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

  Future<List<FolderItem>> _fetchDataSource({
    required int folderId,
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();

    return await _learnedWordFolderItemService.findByFolderIdAndUserId(
      folderId: folderId,
      userId: userId,
    );
  }

  String get _appBarTitle {
    switch (widget.folderType) {
      case FolderType.none:
        throw UnimplementedError();
      case FolderType.word:
        return 'Words List';
      case FolderType.voice:
        return 'Voice Playlist';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: _appBarTitle,
            subTitle: 'Folder: ${widget.folderName}',
          ),
          actions: [
            if (widget.folderType == FolderType.voice)
              IconButton(
                icon: const Icon(Icons.play_circle),
                onPressed: () async {
                  for (final folderItem in _folderItems) {
                    await AudioPlayerUtils.play(
                      ttsVoiceUrls: folderItem.learnedWord!.ttsVoiceUrls,
                    );
                  }
                },
              ),
          ],
          body: FutureBuilder(
            future: _fetchDataSource(folderId: widget.folderId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<FolderItem> items = snapshot.data;

              if (items.isEmpty) {
                return const Center(
                  child: Text('No Items'),
                );
              }

              _folderItems = List.from(items);

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, int index) => CommonLearnedWordCard(
                  learnedWord: items[index].learnedWord!,
                  folderType: widget.folderType,
                  onPressedDeleteItem: () async {
                    await _learnedWordFolderItemService.delete(
                      items[index],
                    );

                    super.setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      );
}
