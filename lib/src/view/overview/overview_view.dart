// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/const/filter_pattern.dart';
import 'package:duo_tracker/src/component/const/match_pattern.dart';
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_filter_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_search_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/switch_language_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_sort_method_dialog.dart';
import 'package:duo_tracker/src/http/duolingo_page_launcher.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/lesson_tips_view.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_view.dart';
import 'package:duo_tracker/src/view/overview/word_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  static const unavailableText = 'N/A';

  bool _alreadyAuthDialogOpened = false;
  String _appBarSubTitle = '';
  final _audioPlayer = AudioPlayer();
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');
  FilterPattern _filterPattern = FilterPattern.none;

  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  MatchPattern _matchPattern = MatchPattern.partial;
  String _searchWord = '';
  bool _searching = false;
  List<String> _selectedFilterItems = [];

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
      showLoadingDialog(
        context: context,
        title: 'Updating Words',
        future: _syncLearnedWords(),
      );
    }

    return await _searchLearnedWords();
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

  Future<void> _syncLearnedWords() async {
    if (!_alreadyAuthDialogOpened) {
      _alreadyAuthDialogOpened = true;

      if (!await DuolingoApiUtils.refreshVersionInfo(context: context)) {
        return;
      }

      await DuolingoApiUtils.authenticateAccount(context: context);

      if (!await DuolingoApiUtils.refreshUser(context: context)) {
        return;
      }

      if (!await DuolingoApiUtils.synchronizeLearnedWords(context: context)) {
        return;
      }

      await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview.setInt(
        DateTime.now().millisecondsSinceEpoch,
      );

      await _buildAppBarSubTitle();

      _alreadyAuthDialogOpened = false;
    }
  }

  Future<List<LearnedWord>> _searchLearnedWords() async =>
      await _learnedWordService.findByUserIdAndLearningLanguageAndFromLanguage(
        await CommonSharedPreferencesKey.userId.getString(),
        await CommonSharedPreferencesKey.currentLearningLanguage.getString(),
        await CommonSharedPreferencesKey.currentFromLanguage.getString(),
      );

  Widget _buildLearnedWordCard({
    required LearnedWord learnedWord,
  }) =>
      Visibility(
        key: Key('${learnedWord.sortOrder}'),
        visible: WordFilter.execute(
          overviewTabType: widget.overviewTabType,
          learnedWord: learnedWord,
          searching: _searching,
          searchWord: _searchWord,
          matchPattern: _matchPattern,
          filterPattern: _filterPattern,
          selectedFilterItems: _selectedFilterItems,
        ),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCardHeaderText(
                      title: '${learnedWord.sortOrder + 1}',
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
                _divider,
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCardHeaderText(
                        title: learnedWord.pos.isEmpty
                            ? unavailableText
                            : learnedWord.pos,
                        subTitle: 'Pos',
                      ),
                      _buildCardHeaderText(
                        title: learnedWord.infinitive.isEmpty
                            ? unavailableText
                            : learnedWord.infinitive,
                        subTitle: 'Infinitive',
                      ),
                      _buildCardHeaderText(
                        title: learnedWord.gender.isEmpty
                            ? unavailableText
                            : learnedWord.gender,
                        subTitle: 'Gender',
                      ),
                      _buildCardHeaderText(
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
    await _buildAppBarSubTitle();
  }

  Future<void> _buildAppBarSubTitle() async {
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();
    final fromLanguageName =
        LanguageConverter.toName(languageCode: fromLanguage);
    final learningLanguageName =
        LanguageConverter.toName(languageCode: learningLanguage);

    super.setState(() {
      _appBarSubTitle = '$fromLanguageName → $learningLanguageName';
    });
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
              onPressed: () async =>
                  await DuolingoPageLauncher.learnWord.build.execute(
                context: context,
                params: {
                  'learningLanguage': learnedWord.formalLearningLanguage,
                  'skillUrlTitle': learnedWord.skillUrlTitle,
                },
              ),
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

  Widget _buildSearchBar() => Container(
        margin: const EdgeInsets.fromLTRB(40, 5, 40, 5),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.filter_list_alt),
              onPressed: () async {
                await showSelectSearchMethodDialog(context: context);
              },
            ),
            hintText: 'Search Word',
            filled: true,
            fillColor:
                Theme.of(context).colorScheme.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          onChanged: (searchWord) async {
            final matchPatternCode =
                await CommonSharedPreferencesKey.matchPattern.getInt();

            super.setState(() {
              _searchWord = searchWord;
              _matchPattern = MatchPatternExt.toEnum(code: matchPatternCode);
            });
          },
        ),
      );

  List<Widget> _buildActions() {
    if (_searching) {
      return [
        IconButton(
          tooltip: 'Clear Search Result',
          icon: const Icon(Icons.clear),
          onPressed: () {
            super.setState(() {
              _searching = false;
              _searchWord = '';
            });
          },
        ),
      ];
    }

    return [
      IconButton(
        tooltip: 'Show Search Bar',
        icon: const Icon(Icons.search),
        onPressed: () {
          super.setState(() {
            _searching = true;
          });
        },
      ),
    ];
  }

  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) =>
      SpeedDialChild(
        child: Icon(
          icon,
          size: 19,
        ),
        label: label,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: SpeedDial(
          tooltip: 'Show Actions',
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.sort,
              label: 'Sort',
              onTap: () async {
                await showSelectSortMethodDialog(context: context);
                await _searchLearnedWords();
                super.setState(() {});
              },
            ),
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.filter,
              label: 'Filter',
              onTap: () async {
                await showSelectFilterMethodDialog(
                  context: context,
                  onPressedOk: (filterPattern, selectedItems) {
                    super.setState(() {
                      _filterPattern = filterPattern;
                      _selectedFilterItems = List.from(selectedItems);
                    });
                  },
                );
              },
            ),
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.sync,
              label: 'Sync Words',
              onTap: () async {
                showLoadingDialog(
                  context: context,
                  title: 'Updating Words',
                  future: _syncLearnedWords(),
                );

                super.setState(() {});
              },
            ),
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.language,
              label: 'Switch Language',
              onTap: () async {
                if (!await Network.isConnected()) {
                  showNetworkErrorDialog(context: context);
                  return;
                }

                showLoadingDialog(
                  context: context,
                  title: 'Switching Language',
                  future: showSwitchLanguageDialog(
                    context: context,
                    onSubmitted: (fromLanguage, learningLanguage) async {
                      await _searchLearnedWords();

                      super.setState(() {
                        _buildAppBarSubTitle();
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: CommonNestesScrollView(
          title: _searching
              ? _buildSearchBar()
              : CommonAppBarTitles(
                  title: _appBarTitle,
                  subTitle: _appBarSubTitle,
                ),
          actions: _buildActions(),
          body: FutureBuilder(
            future: _fetchDataSource(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Loading...',
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
                  itemBuilder: (context, index) => _buildLearnedWordCard(
                    learnedWord: learnedWords[index],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
