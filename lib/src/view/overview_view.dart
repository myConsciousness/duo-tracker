// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/component/common_app_bar_titles.dart';
import 'package:duovoc/src/http/api_adapter.dart';
import 'package:duovoc/src/preference/common_shared_preferences_key.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/model/word_hint_model.dart';
import 'package:duovoc/src/repository/service/learned_word_service.dart';
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
        ),
        body: Container(
          child: FutureBuilder(
            future: this._fetchLearnedWords(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final List<LearnedWord> learnedWords = snapshot.data;

              return ReorderableListView.builder(
                itemCount: learnedWords.length,
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }

                  this._swapSortOrder(
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
                                  subtitle: 'Lesson'),
                              this._createCardHeaderText(
                                title: '${learnedWord.strengthBars}',
                                subtitle: 'Level',
                              ),
                              this._createCardHeaderText(
                                title:
                                    '${(learnedWord.strength * 100.0).toStringAsFixed(2)} %',
                                subtitle: 'Proficiency',
                              ),
                              this._createCardHeaderText(
                                  title: this._datetimeFormat.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            learnedWord.lastPracticedMs),
                                      ),
                                  subtitle: 'Last practiced at'),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
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

                                  super.setState(() {});

                                  await this._learnedWordService.update(
                                        learnedWord,
                                      );
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
                                icon: Icon(Icons.info),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.done),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.hide_source),
                                onPressed: () {},
                              )
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
    await ApiAdapter.of(type: ApiAdapterType.login).execute(context: context);
    await ApiAdapter.of(type: ApiAdapterType.overview)
        .execute(context: context);

    return await this._learnedWordService.findByUserIdAndNotDeleted(
          await CommonSharedPreferencesKey.userId.getString(),
        );
  }

  Widget _createCardHeaderText({
    required String title,
    required String subtitle,
  }) =>
      Column(
        children: [
          Text(
            subtitle,
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

  void _swapSortOrder({
    required List<LearnedWord> learnedWords,
    required int oldIndex,
    required int newIndex,
  }) async {
    final removedLearnedWord = learnedWords.removeAt(oldIndex);
    learnedWords.insert(newIndex, removedLearnedWord);

    final learnedWord = learnedWords.elementAt(newIndex);

    int oldSortOrder = removedLearnedWord.sortOrder;
    removedLearnedWord.sortOrder = learnedWord.sortOrder;
    learnedWord.sortOrder = oldSortOrder;

    await this._learnedWordService.update(removedLearnedWord);
    await this._learnedWordService.update(learnedWord);
  }
}
