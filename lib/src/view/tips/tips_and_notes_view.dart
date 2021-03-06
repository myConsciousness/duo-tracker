// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/admob/banner_ad_list.dart';
import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/tip_and_note_service.dart';
import 'package:duo_tracker/src/view/lesson_tips_view.dart';
import 'package:duo_tracker/src/view/tips/tips_and_notes_tab_type.dart';

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
  /// The app bar title
  final String _appBarTitle = 'Tips & Notes';

  /// The banner ad list
  final _bannerAdList = BannerAdList.newInstance();

  /// The tip and note service
  final _tipAndNoteService = TipAndNoteService.getInstance();

  @override
  void dispose() {
    _bannerAdList.dispose();
    super.dispose();
  }

  Widget _buildTipAndNoteCard({
    required TipAndNote tipAndNote,
    required int index,
  }) =>
      Column(
        key: Key('${tipAndNote.sortOrder}'),
        children: [
          FutureBuilder(
            future: BannerAdUtils.canShow(
              index: index,
              interval: 3,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || !snapshot.data) {
                return Container();
              }

              return BannerAdUtils.createBannerAdWidget(
                _bannerAdList.loadNewBanner(),
              );
            },
          ),
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
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(Icons.more),
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              tipAndNote.skillName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                      ),
                      IconButton(
                        tooltip: tipAndNote.bookmarked
                            ? 'Remove Bookmark'
                            : 'Add Bookmark',
                        icon: tipAndNote.bookmarked
                            ? const Icon(Icons.bookmark_added)
                            : const Icon(Icons.bookmark_add),
                        onPressed: () async {
                          tipAndNote.bookmarked = !tipAndNote.bookmarked;
                          tipAndNote.updatedAt = DateTime.now();

                          await _tipAndNoteService.update(
                            tipAndNote,
                          );

                          super.setState(() {});
                        },
                      ),
                    ],
                  ),
                  const CommonDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: tipAndNote.deleted ? 'Restore' : 'Delete',
                        icon: tipAndNote.deleted
                            ? const Icon(Icons.restore_from_trash)
                            : const Icon(Icons.delete),
                        onPressed: () async {
                          tipAndNote.deleted = !tipAndNote.deleted;
                          tipAndNote.updatedAt = DateTime.now();

                          await _tipAndNoteService.update(tipAndNote);
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
          title: CommonAppBarTitles(title: _appBarTitle),
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
