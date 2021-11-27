// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/admob/interstitial_ad_utils.dart';
import 'package:duo_tracker/src/component/common_dialog_cancel_button.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/filter_pattern.dart';
import 'package:duo_tracker/src/component/dialog/warning_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';

late AwesomeDialog _dialog;

FilterPattern _filterPattern = FilterPattern.lesson;
late List<String> _dataSource;
late List<String> _selectedItems;

/// The learned word service
final _learnedWordService = LearnedWordService.getInstance();

Future<T?> showSelectFilterMethodDialog<T>({
  required BuildContext context,
  required List<String> selectedItems,
  required Function(FilterPattern filterPattern, List<String> selectedItems)
      onPressedOk,
}) async {
  final userId = await CommonSharedPreferencesKey.userId.getString();
  final learningLanguage =
      await CommonSharedPreferencesKey.currentLearningLanguage.getString();
  final fromLanguage =
      await CommonSharedPreferencesKey.currentFromLanguage.getString();

  await _refreshDataSource(
    filterPattern: _filterPattern,
    userId: userId,
    learningLanguage: learningLanguage,
    fromLanguage: fromLanguage,
  );

  _selectedItems = selectedItems;

  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.QUESTION,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const CommonDialogTitle(title: 'Filter Options'),
                const SizedBox(
                  height: 20,
                ),
                CommonTwoGridsRadioListTile(
                  label: 'Filter Pattern',
                  dataSource: const {
                    'Lesson': FilterPattern.lesson,
                    'Pos': FilterPattern.pos,
                    'Infinitive': FilterPattern.infinitive,
                    'Gender': FilterPattern.gender,
                    'Strength': FilterPattern.strength,
                    'None': FilterPattern.none,
                  },
                  groupValue: _filterPattern,
                  onChanged: (value) async {
                    await _refreshDataSource(
                      filterPattern: value,
                      userId: userId,
                      learningLanguage: learningLanguage,
                      fromLanguage: fromLanguage,
                    );

                    setState(() {
                      _filterPattern = value;
                      _selectedItems = [];
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Filter Item',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    left: 10,
                    right: 10,
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 0.0,
                      children: _buildChoiceList(
                        context: context,
                        setState: setState,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'selected ${_selectedItems.length} items',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedItems = List.from(_dataSource);
                            });
                          },
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedItems.clear();
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommonDialogSubmitButton(
                      title: 'Apply',
                      pressEvent: () async {
                        if (_filterPattern != FilterPattern.none &&
                            _selectedItems.isEmpty) {
                          await showWarningDialog(
                            context: context,
                            title: 'Input Error',
                            content: 'Select at least one filter item.',
                          );

                          return;
                        }

                        onPressedOk.call(_filterPattern, _selectedItems);

                        InfoSnackbar.from(context: context).show(
                          content: 'The selected filter have been applied.',
                        );

                        _dialog.dismiss();

                        await InterstitialAdUtils.showInterstitialAd(
                          context: context,
                          sharedPreferencesKey:
                              InterstitialAdSharedPreferencesKey
                                  .countFilterWords,
                        );
                      },
                    ),
                    CommonDialogCancelButton(
                      onPressEvent: () async => await _dialog.dismiss(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await _dialog.show();
}

Future<void> _refreshDataSource({
  required FilterPattern filterPattern,
  required String userId,
  required String learningLanguage,
  required String fromLanguage,
}) async {
  if (filterPattern == FilterPattern.none) {
    _dataSource = [];
    return;
  }

  _dataSource = await _learnedWordService
      .findDistinctFilterPatternByUserIdAndLearningLanguageAndFromLanguage(
    filterPattern: filterPattern,
    userId: userId,
    learningLanguage: learningLanguage,
    fromLanguage: fromLanguage,
  );
}

List<Widget> _buildChoiceList({
  required BuildContext context,
  required Function(void Function()) setState,
}) {
  final List<Widget> choices = [];
  for (final String item in _dataSource) {
    final bool alreadySelected = _selectedItems.contains(item);
    choices.add(
      _ChoiceChipWidget(
        item: item,
        onSelected: (value) {
          setState(() {
            if (alreadySelected) {
              _selectedItems.remove(item);
            } else {
              _selectedItems.add(item);
            }
          });
        },
        selected: alreadySelected,
        text: item.isEmpty ? 'N/A' : item,
      ),
    );
  }

  choices.add(
    SizedBox(
      height: 20,
      width: MediaQuery.of(context).size.width,
    ),
  );

  return choices;
}

class _ChoiceChipWidget<T> extends StatelessWidget {
  const _ChoiceChipWidget({
    Key? key,
    this.text,
    this.item,
    this.selected,
    this.onSelected,
  }) : super(key: key);

  final Function(bool)? onSelected;
  final T? item;
  final bool? selected;
  final String? text;

  TextStyle _getSelectedTextStyle(BuildContext context) => selected!
      ? TextStyle(color: Theme.of(context).colorScheme.onSurface)
      : const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ChoiceChip(
          label: Text(
            '$text',
            style: _getSelectedTextStyle(context),
          ),
          selected: selected!,
          onSelected: onSelected,
        ),
      );
}
