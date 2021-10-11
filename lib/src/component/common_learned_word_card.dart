// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:clipboard/clipboard.dart';
import 'package:duo_tracker/src/component/common_card_header_text.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_text.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_folder_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/utils/audio_player_utils.dart';
import 'package:duo_tracker/src/view/overview/lesson_tips_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonLearnedWordCard extends StatefulWidget {
  const CommonLearnedWordCard({
    Key? key,
    required this.learnedWord,
    required this.folderType,
    this.onPressedComplete,
    this.onPressedTrash,
    this.onPressedDeleteItem,
  }) : super(key: key);

  /// The on press action for complete button
  final Function()? onPressedComplete;

  /// The on press action for trash button
  final Function()? onPressedTrash;

  /// The on press action for delete item button
  final Function()? onPressedDeleteItem;

  /// The learned word
  final LearnedWord learnedWord;

  /// The folder type
  final FolderType folderType;

  @override
  _CommonLearnedWordCardState createState() => _CommonLearnedWordCardState();
}

class _CommonLearnedWordCardState extends State<CommonLearnedWordCard> {
  /// The text represents unavailable
  static const unavailableText = 'N/A';

  /// The datetime format
  final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

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
          if (!await Network.isConnected()) {
            await showNetworkErrorDialog(context: context);
            return;
          }

          await AudioPlayerUtils.play(
            ttsVoiceUrls: learnedWord.ttsVoiceUrls,
          );
        },
      );

  Widget _buildCardHintText({
    required List<WordHint> wordHints,
  }) {
    final hintTexts = <CommonText>[];

    for (final wordHint in wordHints) {
      hintTexts.add(
        CommonText(
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

  Widget _buildCardTitleText({
    required LearnedWord learnedWord,
  }) {
    if (learnedWord.normalizedString.isEmpty ||
        learnedWord.normalizedString.endsWith(' ')) {
      return CommonText(
        text: learnedWord.wordString,
        fontSize: 18,
        bold: true,
      );
    }

    if (learnedWord.wordString == learnedWord.normalizedString) {
      return CommonText(
        text: learnedWord.wordString,
        fontSize: 18,
        bold: true,
      );
    }

    return Flexible(
      child: CommonText(
        text: '${learnedWord.wordString} (${learnedWord.normalizedString})',
        fontSize: 18,
        bold: true,
      ),
    );
  }

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
              onPressed: widget.onPressedTrash,
            ),
            if (!learnedWord.deleted)
              IconButton(
                tooltip: learnedWord.completed ? 'Undo' : 'Complete',
                icon: learnedWord.completed
                    ? const Icon(Icons.undo)
                    : const Icon(Icons.done),
                onPressed: widget.onPressedComplete,
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (learnedWord.tipsAndNotes != null)
              IconButton(
                tooltip: 'Show Tips & Notes',
                icon: const Icon(Icons.more),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonTipsView(
                      lessonName: learnedWord.skill,
                      html: learnedWord.tipsAndNotes!.content,
                    ),
                  ),
                ),
              ),
            IconButton(
              tooltip: 'Store In Folder',
              icon: const Icon(Icons.create_new_folder),
              onPressed: () async {
                await showSelectFolderDialog(
                  context: context,
                  wordId: learnedWord.wordId,
                );
              },
            ),
            //! It will be forcibly redirected to the official app side to the learning page.
            // IconButton(
            //   tooltip: 'Learn at Duolingo',
            //   icon: const Icon(Icons.school),
            //   onPressed: () async =>
            //       await DuolingoPageLauncher.learnWord.build.execute(
            //     context: context,
            //     params: {
            //       'learningLanguage': learnedWord.formalLearningLanguage,
            //       'skillUrlTitle': learnedWord.skillUrlTitle,
            //     },
            //   ),
            // ),
          ],
        ),
      ];

  bool _canShowHeader() =>
      widget.folderType == FolderType.none ||
      widget.folderType == FolderType.word;

  bool _canShowBottomActions() => widget.folderType == FolderType.none;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_canShowHeader())
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonCardHeaderText(
                      subtitle: 'Index',
                      title: '${widget.learnedWord.sortOrder + 1}',
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Lesson',
                      title: widget.learnedWord.skillUrlTitle,
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Strength',
                      title: '${widget.learnedWord.strengthBars}',
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Last practiced at',
                      title: _datetimeFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.learnedWord.lastPracticedMs),
                      ),
                    ),
                  ],
                ),
              if (_canShowHeader()) const CommonDivider(),
              if (_canShowHeader())
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonCardHeaderText(
                        subtitle: 'Pos',
                        title: widget.learnedWord.pos.isEmpty
                            ? unavailableText
                            : widget.learnedWord.pos,
                      ),
                      CommonCardHeaderText(
                        subtitle: 'Infinitive',
                        title: widget.learnedWord.infinitive.isEmpty
                            ? unavailableText
                            : widget.learnedWord.infinitive,
                      ),
                      CommonCardHeaderText(
                        subtitle: 'Gender',
                        title: widget.learnedWord.gender.isEmpty
                            ? unavailableText
                            : widget.learnedWord.gender,
                      ),
                      CommonCardHeaderText(
                        subtitle: 'Proficiency',
                        title:
                            '${(widget.learnedWord.strength * 100.0).toStringAsFixed(2)} %',
                      ),
                    ],
                  ),
                ),
              if (_canShowHeader()) const CommonDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: _buildCardLeading(
                        learnedWord: widget.learnedWord,
                      ),
                      title: Row(
                        children: [
                          _buildCardTitleText(
                            learnedWord: widget.learnedWord,
                          ),
                          if (widget.folderType != FolderType.voice)
                            IconButton(
                              tooltip: 'Copy Word',
                              icon: const Icon(Icons.copy_all, size: 20),
                              onPressed: () async {
                                await FlutterClipboard.copy(
                                    widget.learnedWord.wordString);
                                InfoSnackbar.from(context: context).show(
                                    content:
                                        'Copied "${widget.learnedWord.wordString}" to clipboard.');
                              },
                            )
                        ],
                      ),
                      subtitle: _buildCardHintText(
                        wordHints: widget.learnedWord.wordHints,
                      ),
                    ),
                  ),
                  if (widget.folderType == FolderType.none &&
                      !widget.learnedWord.deleted)
                    IconButton(
                      tooltip: widget.learnedWord.bookmarked
                          ? 'Remove Bookmark'
                          : 'Add Bookmark',
                      icon: widget.learnedWord.bookmarked
                          ? const Icon(Icons.bookmark_added)
                          : const Icon(Icons.bookmark_add),
                      onPressed: () async {
                        widget.learnedWord.bookmarked =
                            !widget.learnedWord.bookmarked;
                        widget.learnedWord.updatedAt = DateTime.now();

                        await _learnedWordService.update(
                          widget.learnedWord,
                        );

                        super.setState(() {});
                      },
                    ),
                  if (widget.folderType != FolderType.none)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async => widget.onPressedDeleteItem,
                    ),
                ],
              ),
              if (_canShowBottomActions()) const CommonDivider(),
              if (_canShowBottomActions())
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _createCardActions(
                    learnedWord: widget.learnedWord,
                  ),
                ),
            ],
          ),
        ),
      );
}
