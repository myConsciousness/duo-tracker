// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/sort_item.dart';
import 'package:duo_tracker/src/component/const/sort_pattern.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';

late AwesomeDialog _dialog;
late SortItem _sortItem;
late SortPattern _sortPattern;

Future<T?> showSelectSortMethodDialog<T>({
  required BuildContext context,
}) async {
  final sortItemCode = await CommonSharedPreferencesKey.sortItem.getInt();
  _sortItem = SortItemExt.toEnum(code: sortItemCode);

  final sortPatternCode = await CommonSharedPreferencesKey.sortPattern.getInt();
  _sortPattern = SortPatternExt.toEnum(code: sortPatternCode);

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
                    'Sort Options',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    CommonTwoGridsRadioListTile(
                      label: 'Sort Item',
                      dataSource: const {
                        'Index': SortItem.defaultIndex,
                        'Proficiency': SortItem.proficiency,
                        'Strength': SortItem.strength,
                        'Lesson': SortItem.lesson,
                        'Pos': SortItem.pos,
                        'Infinitive': SortItem.infinitive,
                        'Gender': SortItem.gender,
                        'Last Practiced': SortItem.lastPracticed,
                      },
                      groupValue: _sortItem,
                      onChanged: (value) {
                        setState(() {
                          _sortItem = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonTwoGridsRadioListTile(
                      label: 'Sort Pattern',
                      dataSource: const {
                        'Asc': SortPattern.asc,
                        'Desc': SortPattern.desc,
                      },
                      groupValue: _sortPattern,
                      onChanged: (value) {
                        setState(() {
                          _sortPattern = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Apply',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    await CommonSharedPreferencesKey.sortItem
                        .setInt(_sortItem.code);
                    await CommonSharedPreferencesKey.sortPattern
                        .setInt(_sortPattern.code);

                    _dialog.dismiss();
                  },
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Cancel',
                  color: Theme.of(context).colorScheme.error,
                  pressEvent: () {
                    _dialog.dismiss();
                  },
                ),
                const SizedBox(
                  height: 30,
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