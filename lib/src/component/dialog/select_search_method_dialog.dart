// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/match_pattern.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';

late AwesomeDialog _dialog;
late MatchPattern _matchPattern;

Future<T?> showSelectSearchMethodDialog<T>({
  required BuildContext context,
  bool setDefault = false,
}) async {
  _matchPattern = MatchPatternExt.toEnum(code: await _getMatchPatternCode());

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
                    height: 25,
                  ),
                  CommonTwoGridsRadioListTile(
                    label: 'Match Pattern',
                    dataSource: const {
                      'Partial': MatchPattern.partial,
                      'Exact': MatchPattern.exact,
                      'Prefix': MatchPattern.prefix,
                      'Suffix': MatchPattern.suffix,
                    },
                    groupValue: _matchPattern,
                    onChanged: (value) {
                      setState(() {
                        _matchPattern = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AnimatedButton(
                    isFixedHeight: false,
                    text: 'Apply',
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    pressEvent: () async {
                      if (setDefault) {
                        await CommonSharedPreferencesKey
                            .overviewDefaultMatchPattern
                            .setInt(_matchPattern.code);
                      } else {
                        await CommonSharedPreferencesKey.matchPattern
                            .setInt(_matchPattern.code);
                      }

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

Future<int> _getMatchPatternCode() async {
  final code = await CommonSharedPreferencesKey.matchPattern.getInt();

  if (code > -1) {
    return code;
  }

  return await CommonSharedPreferencesKey.overviewDefaultMatchPattern.getInt();
}
