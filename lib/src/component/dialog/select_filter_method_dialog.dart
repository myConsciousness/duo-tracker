// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/dialog/warning_dialog.dart';
import 'package:flutter/material.dart';

late AwesomeDialog _dialog;

FilterItem _filterItem = FilterItem.lesson;

var test = [
  'Hiragana-3',
  'test2',
  'test3',
  'test4',
  'test5',
  'test6',
  'test7',
  'test8',
  'test9',
];

List<String> _selectedItems = <String>[];

Future<T?> showSelectFilterMethodDialog<T>({
  required BuildContext context,
  required Function(FilterItem filterItem, List<String> selectedItems)
      onPressedOk,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.QUESTION,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Container(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Center(
                  child: Text(
                    'Search Options',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTwoGridsRadioListTile(
                  label: 'Filter Pattern',
                  dataSource: const {
                    'Lesson': FilterItem.lesson,
                    'Pos': FilterItem.pos,
                    'Infinitive': FilterItem.infinitive,
                    'Gender': FilterItem.gender,
                    'Strength': FilterItem.strength,
                    'None': FilterItem.none,
                  },
                  groupValue: _filterItem,
                  onChanged: (value) {
                    setState(() {
                      _filterItem = value;
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
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, left: 10, right: 10),
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
                              _selectedItems = List.from(test);
                            });
                          },
                          child: const Text('All'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedItems.clear();
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: AnimatedButton(
                        isFixedHeight: false,
                        text: 'Apply',
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        pressEvent: () {
                          if (_filterItem != FilterItem.none &&
                              _selectedItems.isEmpty) {
                            showWarningDialog(
                              context: context,
                              title: 'Input Error',
                              content: 'Select at least one filter item.',
                            );

                            return;
                          }

                          onPressedOk.call(_filterItem, _selectedItems);
                          _dialog.dismiss();
                        },
                      ),
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

enum FilterItem {
  // The none
  none,

  /// The lesson
  lesson,

  /// The strength
  strength,

  /// The pos
  pos,

  /// The infinitive
  infinitive,

  /// The gender
  gender,
}

List<Widget> _buildChoiceList({
  required BuildContext context,
  required Function(void Function()) setState,
}) {
  final List<Widget> choices = [];
  for (final String item in test) {
    bool alreadySelected = _selectedItems.contains(item);
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
        text: item,
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
  Widget build(BuildContext context) => Container(
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
