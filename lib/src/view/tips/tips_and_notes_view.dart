// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/tip_and_note_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/lesson_tips_view.dart';
import 'package:duo_tracker/src/view/tips/tips_and_notes_tab_type.dart';
import 'package:flutter/material.dart';

class TipsAndNotesView extends StatefulWidget {
  const TipsAndNotesView({
    Key? key,
    required this.tipsAndNotesTabType,
  }) : super(key: key);

  /// The tips anfd notes tab type
  final TipsAndNotesTabType tipsAndNotesTabType;

  @override
  _TipsAndNotesViewState createState() => _TipsAndNotesViewState();
}

class _TipsAndNotesViewState extends State<TipsAndNotesView> {
  /// The app bar sub itle
  String _appBarSubTitle = '';

  /// The tip and note service
  final _tipAndNoteService = TipAndNoteService.getInstance();

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
    _buildAppBarSubTitle();
  }

  Widget _buildTipAndNoteCard({
    required TipAndNote tipAndNote,
    required int index,
  }) =>
      Card(
        key: Key('${tipAndNote.sortOrder}'),
        child: ListTile(
          title: Text(tipAndNote.skillName),
          subtitle: Text(tipAndNote.contentSummary),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonTipsView(
                tipAndNote: tipAndNote,
              ),
            ),
          ),
        ),
      );

  Future<void> _sortCards({
    required List<TipAndNote> tipsAndNotes,
    required int oldIndex,
    required int newIndex,
  }) async {
    tipsAndNotes.insert(
      oldIndex < newIndex ? newIndex - 1 : newIndex,
      tipsAndNotes.removeAt(oldIndex),
    );

    // Update all sort orders
    await _tipAndNoteService.replaceSortOrdersByIds(
      tipsAndNotes: tipsAndNotes,
    );
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

  Future<List<TipAndNote>> _fetchDataSource() async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();

    switch (widget.tipsAndNotesTabType) {
      case TipsAndNotesTabType.all:
        return await _tipAndNoteService
            .findByUserIdAndFromLanguageAndLearningLanguageAndDeletedFalse(
          userId: userId,
          fromLanguage: fromLanguage,
          learningLanguage: learningLanguage,
        );
      case TipsAndNotesTabType.bookmarked:
        return await _tipAndNoteService
            .findByUserIdAndFromLanguageAndLearningLanguageAndBookmarkedTrueAndDeletedFalse(
          userId: userId,
          fromLanguage: fromLanguage,
          learningLanguage: learningLanguage,
        );
      case TipsAndNotesTabType.trash:
        return await _tipAndNoteService
            .findByUserIdAndFromLanguageAndLearningLanguageAndDeletedTrue(
          userId: userId,
          fromLanguage: fromLanguage,
          learningLanguage: learningLanguage,
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: 'Tips And Notes',
            subTitle: _appBarSubTitle,
          ),
          body: FutureBuilder(
            future: _fetchDataSource(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<TipAndNote> tipsAndNotes = snapshot.data;

              if (tipsAndNotes.isEmpty) {
                return const Center(
                  child: Text('No Data'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  super.setState(() {});
                },
                child: ReorderableListView.builder(
                  itemCount: tipsAndNotes.length,
                  onReorder: (oldIndex, newIndex) async => await _sortCards(
                    tipsAndNotes: tipsAndNotes,
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  ),
                  itemBuilder: (_, index) => _buildTipAndNoteCard(
                    tipAndNote: tipsAndNotes[index],
                    index: index,
                  ),
                ),
              );
            },
          ),
        ),
      );
}
