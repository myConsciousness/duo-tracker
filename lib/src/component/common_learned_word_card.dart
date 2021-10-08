// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:duo_tracker/src/component/common_card_header_text.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_text.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonLearnedWordCard extends StatefulWidget {
  const CommonLearnedWordCard({
    Key? key,
    required this.learnedWord,
    this.actions,
  }) : super(key: key);

  /// The actions
  final List<Widget>? actions;

  /// The learned word
  final LearnedWord learnedWord;

  @override
  _CommonLearnedWordCardState createState() => _CommonLearnedWordCardState();
}

class _CommonLearnedWordCardState extends State<CommonLearnedWordCard> {
  /// The text represents unavailable
  static const unavailableText = 'N/A';

  /// The audio player
  final _audioPlayer = AudioPlayer();

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

          for (final ttsVoiceUrl in learnedWord.ttsVoiceUrls) {
            // Play all voices.
            // Requires a time to wait for each word to play.
            await _audioPlayer.play(ttsVoiceUrl, volume: 2.0);
            await Future.delayed(const Duration(seconds: 1), () {});
          }
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
              const CommonDivider(),
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
              const CommonDivider(),
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
                  if (!widget.learnedWord.deleted)
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
                ],
              ),
              if (widget.actions != null) const CommonDivider(),
              if (widget.actions != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.actions!,
                ),
            ],
          ),
        ),
      );
}
