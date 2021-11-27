// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_dialog_cancel_button.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/match_pattern.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/utils/shared_preferences_utils.dart';

late AwesomeDialog _dialog;
late MatchPattern _matchPattern;

Future<T?> showSelectSearchMethodDialog<T>({
  required BuildContext context,
  bool setDefault = false,
}) async {
  _matchPattern = MatchPatternExt.toEnum(
    code: await SharedPreferencesUtils.getCurrentIntValueOrDefault(
      currentKey: CommonSharedPreferencesKey.matchPattern,
      defaultKey: CommonSharedPreferencesKey.overviewDefaultMatchPattern,
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
          padding: const EdgeInsets.all(13),
          child: Center(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const CommonDialogTitle(title: 'Search Options'),
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
                  CommonDialogSubmitButton(
                    title: 'Apply',
                    pressEvent: () async {
                      if (setDefault) {
                        await CommonSharedPreferencesKey
                            .overviewDefaultMatchPattern
                            .setInt(_matchPattern.code);
                      } else {
                        await CommonSharedPreferencesKey.matchPattern
                            .setInt(_matchPattern.code);
                      }

                      InfoSnackbar.from(context: context).show(
                        content:
                            'The selected search method have been applied.',
                      );

                      _dialog.dismiss();
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
