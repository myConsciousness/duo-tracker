// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_learned_word_card.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/playlist_folder_item_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/playlist_folder_item_service.dart';
import 'package:flutter/material.dart';

class PlaylistFolderItemsView extends StatefulWidget {
  const PlaylistFolderItemsView({
    Key? key,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  /// The folder code
  final int folderId;

  /// The folder name
  final String folderName;

  @override
  _PlaylistFolderItemsViewState createState() =>
      _PlaylistFolderItemsViewState();
}

class _PlaylistFolderItemsViewState extends State<PlaylistFolderItemsView> {
  /// The audio player
  final _audioPlayer = AudioPlayer();

  /// The learned word folder item service
  final _playlistFolderItemService = PlaylistFolderItemService.getInstance();

  /// The playlist
  late List<PlaylistFolderItem> _playlist;

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

  Future<void> _playAudio({
    required LearnedWord learnedWord,
  }) async {
    for (final ttsVoiceUrl in learnedWord.ttsVoiceUrls) {
      // Play all voices.
      // Requires a time to wait for each word to play.
      await _audioPlayer.play(ttsVoiceUrl, volume: 2.0);
      await Future.delayed(const Duration(seconds: 1), () {});
    }
  }

  Future<List<PlaylistFolderItem>> _fetchDataSource({
    required int folderId,
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();

    final playlistFodlerItems = await _playlistFolderItemService
        .findByFolderIdAndUserIdAndFromLanguageAndLearningLanguage(
      folderId: folderId,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );

    _playlist = playlistFodlerItems;

    return playlistFodlerItems;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Voice Playlist',
            subTitle: 'Folder: ${widget.folderName}',
          ),
          actions: [
            IconButton(
              tooltip: 'Play All',
              icon: const Icon(Icons.play_circle),
              onPressed: () async {
                if (!await Network.isConnected()) {
                  await showNetworkErrorDialog(context: context);
                  return;
                }

                for (final audio in _playlist) {
                  await _playAudio(
                    learnedWord: audio.learnedWord!,
                  );
                }
              },
            ),
          ],
          body: FutureBuilder(
            future: _fetchDataSource(
              folderId: widget.folderId,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<PlaylistFolderItem> items = snapshot.data;

              if (items.isEmpty) {
                return const Center(
                  child: Text('No Items'),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, int index) => CommonLearnedWordCard(
                  learnedWord: items[index].learnedWord!,
                  showHeader: false,
                  showBottomActions: false,
                  isFolder: true,
                  deleteItem: items[index],
                ),
              );
            },
          ),
        ),
      );
}
