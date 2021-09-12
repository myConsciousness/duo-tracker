// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/http/api_adapter.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/view/lesson_tips_view.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({
    Key? key,
    required this.overviewTabType,
  }) : super(key: key);

  final OverviewTabType overviewTabType;

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  static const noneFieldValue = 'N/A';

  final _audioPlayer = AudioPlayer();
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');
  final _learnedWordService = LearnedWordService.getInstance();

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

  Future<List<LearnedWord>> _fetchDataSource({
    required BuildContext context,
  }) async {
    if (await _canAutoSync()) {
      await _syncOverview();
    }

    return _findLearnedWords();
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

  Future<List<LearnedWord>> _findLearnedWords() async =>
      await _learnedWordService.findByUserIdAndLearningLanguageAndFromLanguage(
        await CommonSharedPreferencesKey.userId.getString(),
        await CommonSharedPreferencesKey.currentLearningLanguage.getString(),
        await CommonSharedPreferencesKey.currentFromLanguage.getString(),
      );

  Widget _createLearnedWordCard({
    required LearnedWord learnedWord,
  }) =>
      Visibility(
        key: Key('${learnedWord.sortOrder}'),
        visible: _isCardVisible(learnedWord: learnedWord),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _createCardHeaderText(
                        title: learnedWord.skillUrlTitle, subTitle: 'Lesson'),
                    _createCardHeaderText(
                      title: '${learnedWord.strengthBars}',
                      subTitle: 'Level',
                    ),
                    _createCardHeaderText(
                      title:
                          '${(learnedWord.strength * 100.0).toStringAsFixed(2)} %',
                      subTitle: 'Proficiency',
                    ),
                    _createCardHeaderText(
                        title: _datetimeFormat.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              learnedWord.lastPracticedMs),
                        ),
                        subTitle: 'Last practiced at'),
                  ],
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _createCardHeaderText(
                        title: learnedWord.pos.isEmpty
                            ? noneFieldValue
                            : learnedWord.pos,
                        subTitle: 'Pos',
                      ),
                      _createCardHeaderText(
                        title: learnedWord.infinitive.isEmpty
                            ? noneFieldValue
                            : learnedWord.infinitive,
                        subTitle: 'Infinitive',
                      ),
                      _createCardHeaderText(
                        title: learnedWord.gender.isEmpty
                            ? noneFieldValue
                            : learnedWord.gender,
                        subTitle: 'Gender',
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: _createCardLeading(
                          learnedWord: learnedWord,
                        ),
                        title: _createCardTitleText(
                          learnedWord: learnedWord,
                        ),
                        subtitle: _createCardHintText(
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

                        await _learnedWordService.update(
                          learnedWord,
                        );

                        super.setState(() {});
                      },
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Show Tips & Notes',
                      icon: const Icon(Icons.more),
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
                      icon: const Icon(Icons.done),
                      onPressed: () async {
                        learnedWord.completed = true;
                        learnedWord.updatedAt = DateTime.now();

                        await _learnedWordService.update(learnedWord);

                        super.setState(() {});
                      },
                    ),
                    IconButton(
                      tooltip: 'Hide',
                      icon: const Icon(Icons.hide_source),
                      onPressed: () async {
                        learnedWord.deleted = true;
                        learnedWord.updatedAt = DateTime.now();

                        await _learnedWordService.update(learnedWord);

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
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 11,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      );

  Widget _createCardTitleText({
    required LearnedWord learnedWord,
  }) {
    if (learnedWord.normalizedString.isEmpty ||
        learnedWord.normalizedString.endsWith(' ')) {
      return Text(learnedWord.wordString);
    }

    if (learnedWord.wordString == learnedWord.normalizedString) {
      return Text(learnedWord.wordString);
    }

    return Text('${learnedWord.wordString} (${learnedWord.normalizedString})');
  }

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

  Widget _createCardLeading({
    required LearnedWord learnedWord,
  }) =>
      IconButton(
        tooltip: 'Play Audio',
        icon: const Icon(Icons.play_circle),
        onPressed: () async {
          for (final ttsVoiceUrl in learnedWord.ttsVoiceUrls) {
            await _audioPlayer.play(ttsVoiceUrl, volume: 2.0);
            await Future.delayed(const Duration(seconds: 1), () {});
          }
        },
      );

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
    await _learnedWordService.replaceSortOrdersByIds(learnedWords);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const CommonAppBarTitles(
            title: 'Learned Words',
            subTitle: 'English → Japanese',
          ),
          actions: [
            IconButton(
              tooltip: 'Update Learned Words',
              icon: const Icon(Icons.sync),
              onPressed: () async {
                await _syncOverview();
                super.setState(() {});
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _fetchDataSource(context: context),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
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
                onReorder: (oldIndex, newIndex) async => await _sortCards(
                  learnedWords: learnedWords,
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ),
                itemBuilder: (context, index) => _createLearnedWordCard(
                  learnedWord: learnedWords[index],
                ),
              ),
            );
          },
        ),
      );
}
