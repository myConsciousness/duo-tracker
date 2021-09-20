// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_radio_list_tile.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
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
                Row(
                  children: [
                    Expanded(
                      child: CommonRadioListTile(
                        label: 'Sort Item',
                        dataSource: const {
                          'Index': SortItem.defaultIndex,
                          'Lesson': SortItem.lesson,
                          'Strength': SortItem.strength,
                          'Pos': SortItem.pos,
                          'Infinitive': SortItem.infinitive,
                          'Genger': SortItem.gender,
                          'Proficiency': SortItem.proficiency,
                        },
                        groupValue: _sortItem,
                        onChanged: (value) {
                          setState(() {
                            _sortItem = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CommonRadioListTile(
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

/// The enum that represents sort item.
enum SortItem {
  defaultIndex,
  lesson,
  strength,
  pos,
  infinitive,
  gender,
  proficiency,
}

/// The enum that represents sort pattern.
enum SortPattern {
  asc,
  desc,
}

extension SortItemExt on SortItem {
  int get code {
    switch (this) {
      case SortItem.defaultIndex:
        return 0;
      case SortItem.lesson:
        return 1;
      case SortItem.strength:
        return 2;
      case SortItem.pos:
        return 3;
      case SortItem.infinitive:
        return 4;
      case SortItem.gender:
        return 5;
      case SortItem.proficiency:
        return 6;
    }
  }

  static SortItem toEnum({required final int code}) {
    for (final SortItem sortItem in SortItem.values) {
      if (code == sortItem.code) {
        return sortItem;
      }
    }

    return SortItem.defaultIndex;
  }
}

extension SortPatternExt on SortPattern {
  int get code {
    switch (this) {
      case SortPattern.asc:
        return 0;
      case SortPattern.desc:
        return 1;
    }
  }

  static SortPattern toEnum({required final int code}) {
    for (final SortPattern sortPattern in SortPattern.values) {
      if (code == sortPattern.code) {
        return sortPattern;
      }
    }

    return SortPattern.asc;
  }
}
