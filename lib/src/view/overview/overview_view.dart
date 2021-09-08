// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:duovoc/src/component/common_app_bar_titles.dart';
import 'package:duovoc/src/http/api_adapter.dart';
import 'package:duovoc/src/preference/common_shared_preferences_key.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/model/word_hint_model.dart';
import 'package:duovoc/src/repository/service/learned_word_service.dart';
import 'package:duovoc/src/view/lesson_tips_view.dart';
import 'package:duovoc/src/view/overview/overview_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewView extends StatefulWidget {
  final OverviewTabType overviewTabType;

  OverviewView({
    Key? key,
    required this.overviewTabType,
  }) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final _learnedWordService = LearnedWordService.getInstance();

  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  final _audioPlayer = AudioPlayer();

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
        appBar: AppBar(
          title: CommonAppBarTitles(
            title: 'Learned Words',
            subTitle: 'English → Japanese',
          ),
          actions: [
            IconButton(
              tooltip: 'Update Learned Words',
              icon: Icon(Icons.sync),
              onPressed: () async {
                await this._syncOverview();
                super.setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: this._fetchDataSource(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Loading...'),
                    ],
                  ),
                );
              }

              final List<LearnedWord> learnedWords = snapshot.data;

              return RefreshIndicator(
                onRefresh: () async {
                  super.setState(() {});
                },
                child: ReorderableListView.builder(
                  itemCount: learnedWords.length,
                  onReorder: (oldIndex, newIndex) async =>
                      await this._sortCards(
                    learnedWords: learnedWords,
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  ),
                  itemBuilder: (context, index) => this._createLearnedWordCard(
                    learnedWord: learnedWords[index],
                  ),
                ),
              );
            },
          ),
        ),
      );

  Future<List<LearnedWord>> _fetchDataSource({
    required BuildContext context,
  }) async {
    if (await this._canAutoSync()) {
      await this._syncOverview();
    }

    return this._findLearnedWords();
  }

  Future<bool> _canAutoSync() async => (DateTime.now()
          .difference(
            DateTime.fromMillisecondsSinceEpoch(
              await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview
                  .getInt(),
            ),
          )
          .inDays >=
      7);

  Future<void> _syncOverview() async {
    await ApiAdapter.of(type: ApiAdapterType.login).execute(context: context);
    await ApiAdapter.of(type: ApiAdapterType.overview)
        .execute(context: context);

    await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview.setInt(
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<LearnedWord>> _findLearnedWords() async => await this
      ._learnedWordService
      .findByUserIdAndLearningLanguageAndFromLanguage(
        await CommonSharedPreferencesKey.userId.getString(),
        'ja',
        'en',
      );

  Widget _createLearnedWordCard({
    required LearnedWord learnedWord,
  }) =>
      Visibility(
        key: Key(learnedWord.sortOrder.toString()),
        visible: this._isCardVisible(learnedWord: learnedWord),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    this._createCardHeaderText(
                        title: learnedWord.skillUrlTitle, subTitle: 'Lesson'),
                    this._createCardHeaderText(
                      title: '${learnedWord.strengthBars}',
                      subTitle: 'Level',
                    ),
                    this._createCardHeaderText(
                      title:
                          '${(learnedWord.strength * 100.0).toStringAsFixed(2)} %',
                      subTitle: 'Proficiency',
                    ),
                    this._createCardHeaderText(
                        title: this._datetimeFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  learnedWord.lastPracticedMs),
                            ),
                        subTitle: 'Last practiced at'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: IconButton(
                          tooltip: this._audioPlayer.state == PlayerState.PAUSED
                              ? 'Pause Audio'
                              : 'Play Audio',
                          icon: this._audioPlayer.state == PlayerState.PAUSED
                              ? const Icon(Icons.pause_circle)
                              : const Icon(Icons.play_circle),
                          onPressed: () async {
                            // this._audioPlayer.state ==
                            //         PlayerState.PLAYING
                            //     ? await this._audioPlayer.pause()
                            //     : await this._audioPlayer.play('');
                          },
                        ),
                        title: Text(learnedWord.wordString),
                        subtitle: this._createCardHintText(
                          wordHints: learnedWord.wordHints,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: learnedWord.bookmarked
                          ? 'Remove Bookmark'
                          : 'Add Bookmark',
                      icon: learnedWord.bookmarked
                          ? const Icon(Icons.bookmark_added)
                          : const Icon(Icons.bookmark_add),
                      onPressed: () async {
                        learnedWord.bookmarked = !learnedWord.bookmarked;
                        learnedWord.updatedAt = DateTime.now();

                        await this._learnedWordService.update(
                              learnedWord,
                            );

                        super.setState(() {});
                      },
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Show Tips & Notes',
                      icon: Icon(Icons.more),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonTipsView(
                              lessonName: learnedWord.skill, html: ''),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Complete',
                      icon: Icon(Icons.done),
                      onPressed: () async {
                        learnedWord.completed = true;
                        learnedWord.updatedAt = DateTime.now();

                        await this._learnedWordService.update(learnedWord);

                        super.setState(() {});
                      },
                    ),
                    IconButton(
                      tooltip: 'Hide',
                      icon: Icon(Icons.hide_source),
                      onPressed: () async {
                        learnedWord.deleted = true;
                        learnedWord.updatedAt = DateTime.now();

                        await this._learnedWordService.update(learnedWord);

                        super.setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _createCardHeaderText({
    required String title,
    required String subTitle,
  }) =>
      Column(
        children: [
          Text(
            subTitle,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 11,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      );

  Widget _createCardHintText({
    required List<WordHint> wordHints,
  }) {
    final hintTexts = <Text>[];

    for (final wordHint in wordHints) {
      hintTexts.add(Text('${wordHint.value} : ${wordHint.hint}'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: hintTexts,
    );
  }

  bool _isCardVisible({
    required LearnedWord learnedWord,
  }) {
    if (widget.overviewTabType == OverviewTabType.bookmarked) {
      return learnedWord.bookmarked && !learnedWord.deleted;
    } else if (widget.overviewTabType == OverviewTabType.completed) {
      return learnedWord.completed && !learnedWord.deleted;
    } else if (widget.overviewTabType == OverviewTabType.hidden) {
      return learnedWord.deleted;
    }

    return !learnedWord.completed && !learnedWord.deleted;
  }

  Future<void> _sortCards({
    required List<LearnedWord> learnedWords,
    required int oldIndex,
    required int newIndex,
  }) async {
    learnedWords.insert(
      oldIndex < newIndex ? newIndex - 1 : newIndex,
      learnedWords.removeAt(oldIndex),
    );

    // Update all sort orders
    await this._learnedWordService.replaceSortOrdersByIds(learnedWords);
  }
}
