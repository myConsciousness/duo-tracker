// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/playlist_folder_item_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/playlist_folder_item_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  /// The date format
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  /// The learned word folder item service
  final _playlistFolderItemService = PlaylistFolderItemService.getInstance();

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

  Widget _buildLearnedWordCard({
    required int index,
    required PlaylistFolderItem playlistFolderItem,
  }) {
    final learnedWord = playlistFolderItem.learnedWord;
    return Column(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
              bottom: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCardHeaderText(
                      title: '${learnedWord!.sortOrder + 1}',
                      subTitle: 'Index',
                    ),
                    _buildCardHeaderText(
                      title: learnedWord.skillUrlTitle,
                      subTitle: 'Lesson',
                    ),
                    _buildCardHeaderText(
                      title: '${learnedWord.strengthBars}',
                      subTitle: 'Strength',
                    ),
                    _buildCardHeaderText(
                      title: _datetimeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            learnedWord.lastPracticedMs),
                      ),
                      subTitle: 'Last practiced at',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: _buildCardLeading(
                          learnedWord: learnedWord,
                        ),
                        title: Row(
                          children: [
                            _buildCardTitleText(
                              learnedWord: learnedWord,
                            ),
                            IconButton(
                              tooltip: 'Copy Word',
                              icon: const Icon(Icons.copy_all, size: 20),
                              onPressed: () async {
                                await FlutterClipboard.copy(
                                    learnedWord.wordString);
                                InfoSnackbar.from(context: context).show(
                                    content:
                                        'Copied "${learnedWord.wordString}" to clipboard.');
                              },
                            )
                          ],
                        ),
                        subtitle: _buildCardHintText(
                          wordHints: learnedWord.wordHints,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _playlistFolderItemService.delete(
                          playlistFolderItem,
                        );

                        super.setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardLeading({
    required LearnedWord learnedWord,
  }) =>
      IconButton(
        tooltip: 'Play Audio',
        icon: Icon(
          Icons.play_circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () async {
          for (final ttsVoiceUrl in learnedWord.ttsVoiceUrls) {
            // Play all voices.
            // Requires a time to wait for each word to play.
            await _audioPlayer.play(ttsVoiceUrl, volume: 2.0);
            await Future.delayed(const Duration(seconds: 1), () {});
          }
        },
      );

  Widget _buildCardTitleText({
    required LearnedWord learnedWord,
  }) {
    if (learnedWord.normalizedString.isEmpty ||
        learnedWord.normalizedString.endsWith(' ')) {
      return _buildText(
        text: learnedWord.wordString,
        fontSize: 18,
        boldText: true,
      );
    }

    if (learnedWord.wordString == learnedWord.normalizedString) {
      return _buildText(
        text: learnedWord.wordString,
        fontSize: 18,
        boldText: true,
      );
    }

    return Flexible(
      child: _buildText(
        text: '${learnedWord.wordString} (${learnedWord.normalizedString})',
        fontSize: 18,
        boldText: true,
      ),
    );
  }

  Widget _buildCardHintText({
    required List<WordHint> wordHints,
  }) {
    final hintTexts = <Text>[];

    for (final wordHint in wordHints) {
      hintTexts.add(
        _buildText(
          text: '${wordHint.value} : ${wordHint.hint}',
          fontSize: 13,
          opacity: 0.7,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: hintTexts,
    );
  }

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

  Future<List<PlaylistFolderItem>> _fetchDataSource({
    required int folderId,
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();

    return await _playlistFolderItemService
        .findByFolderIdAndUserIdAndFromLanguageAndLearningLanguage(
      folderId: folderId,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Voice Playlist',
            subTitle: 'Folder: ${widget.folderName}',
          ),
          body: FutureBuilder(
            future: _fetchDataSource(folderId: widget.folderId),
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
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return _buildLearnedWordCard(
                    index: index,
                    playlistFolderItem: item,
                  );
                },
              );
            },
          ),
        ),
      );
}
