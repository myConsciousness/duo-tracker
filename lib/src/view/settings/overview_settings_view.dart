// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/const/match_pattern.dart';
import 'package:duo_tracker/src/component/const/sort_item.dart';
import 'package:duo_tracker/src/component/const/sort_pattern.dart';
import 'package:duo_tracker/src/component/dialog/confirm_dialog.dart';
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_auto_sync_schedule_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_search_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_sort_method_dialog.dart';
import 'package:duo_tracker/src/component/dialog/warning_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewSettingsView extends StatefulWidget {
  const OverviewSettingsView({Key? key}) : super(key: key);

  @override
  _OverviewSettingsViewState createState() => _OverviewSettingsViewState();
}

class _OverviewSettingsViewState extends State<OverviewSettingsView> {
  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  /// The datetime format
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  // The match pattern
  MatchPattern _matchPattern = MatchPattern.partial;

  /// The sort item
  SortItem _sortItem = SortItem.defaultIndex;

  /// The sort pattern
  SortPattern _sortPattern = SortPattern.asc;

  /// The use auto aync
  bool _useAutoSync = true;

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

  Future<void> _asyncInitState() async {
    await _initFilterPattern();

    _useAutoSync = await CommonSharedPreferencesKey.overviewUseAutoSync.getBool(
      defaultValue: true,
    );

    super.setState(() {});
  }

  Future<void> _initFilterPattern() async {
    _matchPattern = MatchPatternExt.toEnum(
        code: await CommonSharedPreferencesKey.overviewDefaultMatchPattern
            .getInt());
    _sortItem = SortItemExt.toEnum(
        code:
            await CommonSharedPreferencesKey.overviewDefaultSortItem.getInt());
    _sortPattern = SortPatternExt.toEnum(
        code: await CommonSharedPreferencesKey.overviewDefaultSortPattern
            .getInt());
  }

  Widget _createListTile({
    required Icon icon,
    required String title,
    String subtitle = '',
    GestureTapCallback? onTap,
  }) =>
      ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle.isEmpty
            ? null
            : Text(
                subtitle,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Overview Settings'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: CommonSharedPreferencesKey.datetimeLastSyncedOverview
                      .getInt(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Loading();
                    }

                    return _createListTile(
                      icon: const Icon(Icons.info),
                      title: 'Last Synced At',
                      subtitle: _datetimeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(snapshot.data),
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: CommonSharedPreferencesKey
                      .datetimeLastAutoSyncedOverview
                      .getInt(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Loading();
                    }

                    return _createListTile(
                      icon: const Icon(Icons.info),
                      title: 'Last Auto Synced At',
                      subtitle: _datetimeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(snapshot.data),
                      ),
                    );
                  },
                ),
                const CommonDivider(),
                Row(
                  children: [
                    Expanded(
                      child: _createListTile(
                          icon: const Icon(Icons.sync),
                          title: 'Use Auto Sync',
                          subtitle:
                              'You can set whether or not to perform automatic synchronization with Duolingo.',
                          onTap: () async {
                            await CommonSharedPreferencesKey.overviewUseAutoSync
                                .setBool(!_useAutoSync);

                            super.setState(() {
                              _useAutoSync = !_useAutoSync;
                            });
                          }),
                    ),
                    Switch(
                      value: _useAutoSync,
                      onChanged: (value) async {
                        await CommonSharedPreferencesKey.overviewUseAutoSync
                            .setBool(value);

                        super.setState(() {
                          _useAutoSync = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _createListTile(
                  icon: const Icon(Icons.calendar_today),
                  title: 'Auto Sync Schedule',
                  subtitle: '',
                  onTap: () async {
                    final useAutoSync = await CommonSharedPreferencesKey
                        .overviewUseAutoSync
                        .getBool();

                    if (!useAutoSync) {
                      await showWarningDialog(
                          context: context,
                          title: 'Auto Sync is disabled',
                          content:
                              'The Auto Sync schedule can be set if Auto Sync is enabled, please enable Auto Sync.');
                      return;
                    }

                    await showSelectAutoSyncScheduleDialog(context: context);
                  },
                ),
                const CommonDivider(),
                _createListTile(
                  icon: const Icon(Icons.search),
                  title: 'Default Match Pattern',
                  subtitle: _matchPattern.name,
                  onTap: () async {
                    await showSelectSearchMethodDialog(
                      context: context,
                      setDefault: true,
                    );

                    final matchPattern = MatchPatternExt.toEnum(
                      code: await CommonSharedPreferencesKey
                          .overviewDefaultMatchPattern
                          .getInt(),
                    );

                    super.setState(() {
                      _matchPattern = matchPattern;
                    });
                  },
                ),
                _createListTile(
                  icon: const Icon(Icons.sort),
                  title: 'Default Sort Pattern',
                  subtitle: '${_sortItem.name} (${_sortPattern.name})',
                  onTap: () async {
                    await showSelectSortMethodDialog(
                      context: context,
                      setDefault: true,
                    );

                    final sortItem = SortItemExt.toEnum(
                      code: await CommonSharedPreferencesKey
                          .overviewDefaultSortItem
                          .getInt(),
                    );
                    final sortPattern = SortPatternExt.toEnum(
                      code: await CommonSharedPreferencesKey
                          .overviewDefaultSortPattern
                          .getInt(),
                    );

                    super.setState(() {
                      _sortItem = sortItem;
                      _sortPattern = sortPattern;
                    });
                  },
                ),
                const CommonDivider(),
                _createListTile(
                  icon: const Icon(Icons.reorder),
                  title: 'Reset Sort Order',
                  subtitle:
                      'You can reset the order of the words in the list. This operation will not reset the order of words in the folder.',
                  onTap: () async => await showConfirmDialog(
                    context: context,
                    title: 'Reset Word Orders',
                    content:
                        'Resets the sorted order in the word list. This will not reset the order of the words in the folder. Are you sure?',
                    onPressedOk: () async {
                      final userId =
                          await CommonSharedPreferencesKey.userId.getString();
                      final learningLanguage = await CommonSharedPreferencesKey
                          .currentLearningLanguage
                          .getString();
                      final fromLanguage = await CommonSharedPreferencesKey
                          .currentFromLanguage
                          .getString();

                      await showLoadingDialog(
                        context: context,
                        title: 'Resetting Word Orders',
                        future: _learnedWordService
                            .resetSortOrderByUserIdAndLearningLanguageAndFromLanguage(
                          userId: userId,
                          learningLanguage: learningLanguage,
                          fromLanguage: fromLanguage,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}