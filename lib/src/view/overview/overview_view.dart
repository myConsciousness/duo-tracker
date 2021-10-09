// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_utils.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_learned_word_card.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/const/filter_pattern.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/const/match_pattern.dart';
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_filter_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_search_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/switch_language_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_sort_method_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/overview/overview_tab_type.dart';
import 'package:duo_tracker/src/view/overview/word_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  bool _alreadyAuthDialogOpened = false;
  String _appBarSubTitle = '';
  final List<BannerAd> _bannerAds = <BannerAd>[];
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
    for (final bannerAd in _bannerAds) {
      bannerAd.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  BannerAd _loadBannerAd() {
    final BannerAd bannerAd = BannerAdUtils.loadBannerAd();
    _bannerAds.add(bannerAd);
    return bannerAd;
  }

  Future<List<LearnedWord>> _fetchDataSource() async {
    if (await _canAutoSync()) {
      await _syncLearnedWords();
    }

    return await _searchLearnedWords();
  }

  Future<bool> _canAutoSync() async => (DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(
              await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview
                  .getInt()))
          .inDays
          .abs() >=
      1);

  Future<void> _syncLearnedWords() async {
    if (!_alreadyAuthDialogOpened) {
      _alreadyAuthDialogOpened = true;

      await DuolingoApiUtils.authenticateAccount(context: context);

      await showLoadingDialog(
        context: context,
        title: 'Updating API Config',
        future: DuolingoApiUtils.refreshVersionInfo(context: context),
      );

      await showLoadingDialog(
        context: context,
        title: 'Updating User Information',
        future: DuolingoApiUtils.refreshUser(context: context),
      );

      await showLoadingDialog(
        context: context,
        title: 'Updating Learned Words',
        future: DuolingoApiUtils.synchronizeLearnedWords(context: context),
      );

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
    required int index,
    required LearnedWord learnedWord,
  }) {
    final visible = WordFilter.execute(
      overviewTabType: widget.overviewTabType,
      learnedWord: learnedWord,
      searching: _searching,
      searchWord: _searchWord,
      matchPattern: _matchPattern,
      filterPattern: _filterPattern,
      selectedFilterItems: _selectedFilterItems,
    );

    return Visibility(
      key: Key('${learnedWord.sortOrder}'),
      visible: visible,
      child: Column(
        children: [
          if (visible)
            FutureBuilder(
              future: BannerAdUtils.canShow(
                index: index,
                interval: 10,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || !snapshot.data) {
                  return Container();
                }

                return BannerAdUtils.createBannerAdWidget(_loadBannerAd());
              },
            ),
          CommonLearnedWordCard(
            learnedWord: learnedWord,
            folderType: FolderType.none,
            onPressedComplete: () async {
              learnedWord.completed = !learnedWord.completed;
              learnedWord.updatedAt = DateTime.now();

              await _learnedWordService.update(learnedWord);
              super.setState(() {});
            },
            onPressedTrash: () async {
              learnedWord.deleted = !learnedWord.deleted;
              learnedWord.updatedAt = DateTime.now();

              await _learnedWordService.update(learnedWord);
              super.setState(() {});
            },
          ),
        ],
      ),
    );
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

  Widget _buildSearchBar() => Container(
        margin: const EdgeInsets.fromLTRB(45, 0, 45, 0),
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
          onSubmitted: (_) async {
            await InterstitialAdUtils.showInterstitialAd(
              sharedPreferencesKey:
                  InterstitialAdSharedPreferencesKey.countSearchWords,
            );
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

  List<SpeedDialChild> _buildFloatingActions() => [
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
              selectedItems: _selectedFilterItems,
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
            await _syncLearnedWords();
            super.setState(() {});
          },
        ),
        _buildSpeedDialChild(
          icon: FontAwesomeIcons.language,
          label: 'Switch Language',
          onTap: () async {
            if (!await Network.isConnected()) {
              await showNetworkErrorDialog(context: context);
              return;
            }

            await showLoadingDialog(
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
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: SpeedDial(
          renderOverlay: true,
          switchLabelPosition: true,
          buttonSize: 50,
          childrenButtonSize: 50,
          tooltip: 'Show Actions',
          animatedIcon: AnimatedIcons.menu_close,
          children: _buildFloatingActions(),
        ),
        body: CommonNestedScrollView(
          title: _searching
              ? _buildSearchBar()
              : CommonAppBarTitles(
                  title: _appBarTitle,
                  subTitle: _appBarSubTitle,
                ),
          actions: _buildActions(),
          body: FutureBuilder(
            future: _fetchDataSource(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
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
                  itemBuilder: (_, index) => _buildLearnedWordCard(
                    index: index,
                    learnedWord: learnedWords[index],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
