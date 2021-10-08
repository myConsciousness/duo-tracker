// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_card_header_text.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/common_text.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_item_model.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_item_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LearnedWordFolderItemsView extends StatefulWidget {
  const LearnedWordFolderItemsView({
    Key? key,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  /// The folder code
  final int folderId;

  /// The folder name
  final String folderName;

  @override
  _LearnedWordFolderItemsViewState createState() =>
      _LearnedWordFolderItemsViewState();
}

class _LearnedWordFolderItemsViewState
    extends State<LearnedWordFolderItemsView> {
  static const unavailableText = 'N/A';

  /// The audio player
  final _audioPlayer = AudioPlayer();

  /// The date format
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  /// The learned word folder item service
  final _learnedWordFolderItemService =
      LearnedWordFolderItemService.getInstance();

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
    required LearnedWordFolderItem learnedWordFolderItem,
  }) {
    final learnedWord = learnedWordFolderItem.learnedWord;
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
                    CommonCardHeaderText(
                      subtitle: 'Index',
                      title: '${learnedWord!.sortOrder + 1}',
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Lesson',
                      title: learnedWord.skillUrlTitle,
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Strength',
                      title: '${learnedWord.strengthBars}',
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Last practiced at',
                      title: _datetimeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            learnedWord.lastPracticedMs),
                      ),
                    ),
                  ],
                ),
                const CommonDivider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonCardHeaderText(
                        subtitle: 'Pos',
                        title: learnedWord.pos.isEmpty
                            ? unavailableText
                            : learnedWord.pos,
                      ),
                      CommonCardHeaderText(
                        subtitle: 'Infinitive',
                        title: learnedWord.infinitive.isEmpty
                            ? unavailableText
                            : learnedWord.infinitive,
                      ),
                      CommonCardHeaderText(
                        subtitle: 'Gender',
                        title: learnedWord.gender.isEmpty
                            ? unavailableText
                            : learnedWord.gender,
                      ),
                      CommonCardHeaderText(
                        subtitle: 'Proficiency',
                        title:
                            '${(learnedWord.strength * 100.0).toStringAsFixed(2)} %',
                      ),
                    ],
                  ),
                ),
                const CommonDivider(),
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
                        await _learnedWordFolderItemService.delete(
                          learnedWordFolderItem,
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
      return CommonText(
        text: learnedWord.wordString,
        fontSize: 18,
        bold: true,
      );
    }

    if (learnedWord.wordString == learnedWord.normalizedString) {
      return CommonText(
        text: learnedWord.wordString,
        fontSize: 18,
        bold: true,
      );
    }

    return Flexible(
      child: CommonText(
        text: '${learnedWord.wordString} (${learnedWord.normalizedString})',
        fontSize: 18,
        bold: true,
      ),
    );
  }

  Widget _buildCardHintText({
    required List<WordHint> wordHints,
  }) {
    final hintTexts = <CommonText>[];

    for (final wordHint in wordHints) {
      hintTexts.add(
        CommonText(
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
                  return _buildLearnedWordCard(
                    index: index,
                    learnedWordFolderItem: item,
                  );
                },
              );
            },
          ),
        ),
      );
}
