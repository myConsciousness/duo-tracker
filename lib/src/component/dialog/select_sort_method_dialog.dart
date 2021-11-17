// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_utils.dart';
import 'package:duo_tracker/src/component/common_dialog_cancel_button.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/sort_item.dart';
import 'package:duo_tracker/src/component/const/sort_pattern.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';

late AwesomeDialog _dialog;
late SortItem _sortItem;
late SortPattern _sortPattern;

Future<T?> showSelectSortMethodDialog<T>({
  required BuildContext context,
  bool setDefault = false,
}) async {
  _sortItem = SortItemExt.toEnum(
    code: await SharedPreferencesUtils.getCurrentIntValueOrDefault(
      currentKey: CommonSharedPreferencesKey.sortItem,
      defaultKey: CommonSharedPreferencesKey.overviewDefaultSortItem,
    ),
  );

  _sortPattern = SortPatternExt.toEnum(
    code: await SharedPreferencesUtils.getCurrentIntValueOrDefault(
      currentKey: CommonSharedPreferencesKey.sortPattern,
      defaultKey: CommonSharedPreferencesKey.overviewDefaultSortPattern,
    ),
  );

  _dialog = _buildDialog(context: context, setDefault: setDefault);
  await _dialog.show();
}

AwesomeDialog _buildDialog({
  required BuildContext context,
  required bool setDefault,
}) =>
    AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.QUESTION,
      btnOkColor: Theme.of(context).colorScheme.secondary,
      body: StatefulBuilder(
        builder: (BuildContext context, setState) => Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const CommonDialogTitle(title: 'Sort Options'),
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
                  CommonDialogSubmitButton(
                    title: 'Apply',
                    pressEvent: () async {
                      if (setDefault) {
                        await CommonSharedPreferencesKey.overviewDefaultSortItem
                            .setInt(_sortItem.code);
                        await CommonSharedPreferencesKey
                            .overviewDefaultSortPattern
                            .setInt(_sortPattern.code);
                      } else {
                        await CommonSharedPreferencesKey.sortItem
                            .setInt(_sortItem.code);
                        await CommonSharedPreferencesKey.sortPattern
                            .setInt(_sortPattern.code);
                      }

                      InfoSnackbar.from(context: context).show(
                        content: 'The selected sort order have been applied.',
                      );

                      _dialog.dismiss();

                      await InterstitialAdUtils.showInterstitialAd(
                        context: context,
                        sharedPreferencesKey:
                            InterstitialAdSharedPreferencesKey.countSortWords,
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
            ),
          ),
        ),
      ),
    );
