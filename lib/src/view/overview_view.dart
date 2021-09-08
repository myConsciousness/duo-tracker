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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewView extends StatefulWidget {
  OverviewView({Key? key}) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final _learnedWordService = LearnedWordService.getInstance();

  final DateFormat _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.state;
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
              icon: Icon(Icons.sync),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: this._fetchLearnedWords(context: context),
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

              return ReorderableListView.builder(
                itemCount: learnedWords.length,
                onReorder: (oldIndex, newIndex) async {
                  await this._swapSortOrder(
                    learnedWords: learnedWords,
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  );
                },
                itemBuilder: (context, index) {
                  final learnedWord = learnedWords[index];
                  return Card(
                    elevation: 2.0,
                    key: Key(learnedWords[index].sortOrder.toString()),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              this._createCardHeaderText(
                                  title: learnedWord.skillUrlTitle,
                                  subTitle: 'Lesson'),
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
                                    icon: this._audioPlayer.state ==
                                            PlayerState.PAUSED
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
                                icon: learnedWord.bookmarked
                                    ? const Icon(Icons.bookmark_added)
                                    : const Icon(Icons.bookmark_add),
                                onPressed: () async {
                                  learnedWord.bookmarked =
                                      !learnedWord.bookmarked;
                                  learnedWord.updatedAt = DateTime.now();

                                  super.setState(() async {
                                    await this._learnedWordService.update(
                                          learnedWord,
                                        );
                                  });
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
                                icon: Icon(Icons.more),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LessonTipsView(
                                        lessonName: learnedWord.skill,
                                        html: ''),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.done),
                                onPressed: () {
                                  learnedWord.completed = true;
                                  learnedWord.updatedAt = DateTime.now();

                                  super.setState(() {
                                    this
                                        ._learnedWordService
                                        .update(learnedWord);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.hide_source),
                                onPressed: () {
                                  learnedWord.deleted = true;
                                  learnedWord.updatedAt = DateTime.now();

                                  super.setState(() {
                                    this
                                        ._learnedWordService
                                        .update(learnedWord);
                                  });
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

  Future<List<LearnedWord>> _fetchLearnedWords({
    required BuildContext context,
  }) async {
    if (await this._canAutoSync()) {
      await ApiAdapter.of(type: ApiAdapterType.login).execute(context: context);
      await ApiAdapter.of(type: ApiAdapterType.overview)
          .execute(context: context);

      await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview.setInt(
        DateTime.now().millisecondsSinceEpoch,
      );
    }

    return await this
        ._learnedWordService
        .findByUserIdAndNotCompletedAndNotDeleted(
          await CommonSharedPreferencesKey.userId.getString(),
        );
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

  Future<void> _swapSortOrder({
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
