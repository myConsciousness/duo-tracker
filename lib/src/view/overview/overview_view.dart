// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/http/api_adapter.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/lesson_tips_view.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  bool _alreadyAuthDialogOpened = false;
  String _appBarSubTitle = '';
  final _audioPlayer = AudioPlayer();
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  /// The learned word service
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
    _asyncInitState();
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
    if (!_alreadyAuthDialogOpened) {
      _alreadyAuthDialogOpened = true;

      final username = await CommonSharedPreferencesKey.username.getString();
      final password = Encryption.decode(
          value: await CommonSharedPreferencesKey.password.getString());

      final loginApi = ApiAdapter.of(type: ApiAdapterType.login);

      if (!await loginApi.execute(context: context, params: {
        'username': username,
        'password': password,
      })) {
        return;
      }

      final overviewApi = ApiAdapter.of(type: ApiAdapterType.overview);

      if (!await overviewApi.execute(context: context)) {
        return;
      }

      await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview.setInt(
        DateTime.now().millisecondsSinceEpoch,
      );

      await _createAppBarSubTitle();

      _alreadyAuthDialogOpened = false;
    }
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
                      title: '${learnedWord.sortOrder + 1}',
                      subTitle: 'Index',
                    ),
                    _createCardHeaderText(
                      title: learnedWord.skillUrlTitle,
                      subTitle: 'Lesson',
                    ),
                    _createCardHeaderText(
                      title: '${learnedWord.strengthBars}',
                      subTitle: 'Level',
                    ),
                    _createCardHeaderText(
                      title: _datetimeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            learnedWord.lastPracticedMs),
                      ),
                      subTitle: 'Last practiced at',
                    ),
                  ],
                ),
                _divider,
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
                      _createCardHeaderText(
                        title:
                            '${(learnedWord.strength * 100.0).toStringAsFixed(2)} %',
                        subTitle: 'Proficiency',
                      ),
                    ],
                  ),
                ),
                _divider,
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
                    if (!learnedWord.deleted)
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
                _divider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _createCardActions(
                    learnedWord: learnedWord,
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
              bottom: Radius.circular(30),
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
          _createTextSecondaryColor(
            text: subTitle,
            fontSize: 12,
          ),
          _createTextOnSurfaceColor(
            text: title,
            fontSize: 14,
          ),
        ],
      );

  Widget _createCardTitleText({
    required LearnedWord learnedWord,
  }) {
    if (learnedWord.normalizedString.isEmpty ||
        learnedWord.normalizedString.endsWith(' ')) {
      return _createTextOnSurfaceColor(
        text: learnedWord.wordString,
        fontSize: 18,
      );
    }

    if (learnedWord.wordString == learnedWord.normalizedString) {
      return _createTextOnSurfaceColor(
        text: learnedWord.wordString,
        fontSize: 18,
      );
    }

    return _createTextOnSurfaceColor(
      text: '${learnedWord.wordString} (${learnedWord.normalizedString})',
      fontSize: 18,
    );
  }

  Widget _createCardHintText({
    required List<WordHint> wordHints,
  }) {
    final hintTexts = <Text>[];

    for (final wordHint in wordHints) {
      hintTexts.add(
        _createTextOnSurfaceColor(
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

  bool _isCardVisible({
    required LearnedWord learnedWord,
  }) {
    if (widget.overviewTabType == OverviewTabType.bookmarked) {
      return learnedWord.bookmarked &&
          !learnedWord.completed &&
          !learnedWord.deleted;
    } else if (widget.overviewTabType == OverviewTabType.completed) {
      return learnedWord.completed && !learnedWord.deleted;
    } else if (widget.overviewTabType == OverviewTabType.trash) {
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

  Future<void> _asyncInitState() async {
    await _createAppBarSubTitle();
  }

  Future<void> _createAppBarSubTitle() async {
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();
    final fromLanguageName =
        LanguageConverter.from(languageCode: fromLanguage).execute();
    final learningLanguageName =
        LanguageConverter.from(languageCode: learningLanguage).execute();

    super.setState(() {
      _appBarSubTitle = '$fromLanguageName → $learningLanguageName';
    });
  }

  Text _createTextOnSurfaceColor({
    required String text,
    required double fontSize,
    double opacity = 1.0,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(opacity),
          fontSize: fontSize,
        ),
      );

  Text _createTextSecondaryColor({
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

  List<Widget> _createCardActions({
    required LearnedWord learnedWord,
  }) =>
      <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              tooltip: learnedWord.deleted ? 'Restore' : 'Delete',
              icon: learnedWord.deleted
                  ? const Icon(Icons.restore_from_trash)
                  : const Icon(Icons.delete),
              onPressed: () async {
                learnedWord.deleted = !learnedWord.deleted;
                learnedWord.updatedAt = DateTime.now();

                await _learnedWordService.update(learnedWord);
                super.setState(() {});
              },
            ),
            if (!learnedWord.deleted)
              IconButton(
                tooltip: learnedWord.completed ? 'Undo' : 'Complete',
                icon: learnedWord.completed
                    ? const Icon(Icons.undo)
                    : const Icon(Icons.done),
                onPressed: () async {
                  learnedWord.completed = !learnedWord.completed;
                  learnedWord.updatedAt = DateTime.now();

                  await _learnedWordService.update(learnedWord);
                  super.setState(() {});
                },
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (learnedWord.tipsAndNotes.isNotEmpty)
              IconButton(
                tooltip: 'Show Tips & Notes',
                icon: const Icon(Icons.more),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonTipsView(
                      lessonName: learnedWord.skill,
                      html: learnedWord.tipsAndNotes,
                    ),
                  ),
                ),
              ),
            IconButton(
              tooltip: 'Learn at Duolingo',
              icon: const Icon(Icons.school),
              onPressed: () async {
                if (!await Network.isConnected()) {
                  showAwesomeDialog(
                    context: context,
                    title: 'Network Error',
                    content:
                        'Could not detect a valid network. Please check the network environment and the network settings of the device.',
                    dialogType: DialogType.WARNING,
                  );

                  return;
                }

                await launch(
                    'https://www.duolingo.com/skill/${learnedWord.learningLanguage}/${learnedWord.skillUrlTitle}');
              },
            ),
          ],
        ),
      ];

  String get _appBarTitle {
    switch (widget.overviewTabType) {
      case OverviewTabType.all:
        return 'All Learned Words';
      case OverviewTabType.bookmarked:
        return 'Bookmarked Learned Words';
      case OverviewTabType.completed:
        return 'Completed Learned Words';
      case OverviewTabType.trash:
        return 'Trashed Learned Words';
    }
  }

  Divider get _divider => Divider(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: SpeedDial(
          tooltip: 'Show Actions',
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: const Icon(
                FontAwesomeIcons.searchPlus,
                size: 19,
              ),
              label: 'Search',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              labelBackgroundColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.background,
              onTap: () {},
            ),
            SpeedDialChild(
              child: const Icon(
                FontAwesomeIcons.sync,
                size: 19,
              ),
              label: 'Sync Words',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              labelBackgroundColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.background,
              onTap: () async {
                await _syncOverview();
                super.setState(() {});
              },
            ),
            SpeedDialChild(
              child: const Icon(
                FontAwesomeIcons.language,
                size: 19,
              ),
              label: 'Switch Language',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              labelBackgroundColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.background,
              onTap: () async {
                if (!await Network.isConnected()) {
                  showAwesomeDialog(
                    context: context,
                    title: 'Network Error',
                    content:
                        'Could not detect a valid network. Please check the network environment and the network settings of the device.',
                    dialogType: DialogType.WARNING,
                  );

                  return;
                }
              },
            ),
          ],
        ),
        body: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              centerTitle: true,
              title: CommonAppBarTitles(
                title: _appBarTitle,
                subTitle: _appBarSubTitle,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            )
          ],
          body: FutureBuilder(
            future: _fetchDataSource(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
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
        ),
      );
}
