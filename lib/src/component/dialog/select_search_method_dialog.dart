// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_radio_list_tile.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

AwesomeDialog? _dialog;
MatchPattern _matchPattern = MatchPattern.partial;

enum MatchPattern {
  /// Partial match
  partial,

  /// Exact Match
  exact,

  /// Prefix match
  prefix,

  /// Suffix match
  suffix,
}

Future<T?> showSelectSearchMethodDialog<T>({
  required BuildContext context,
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
                Center(
                  child: Text(
                    'Search Options',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CommonRadioListTile(
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
                    await CommonSharedPreferencesKey.matchPattern
                        .setString(EnumToString.convertToString(_matchPattern));
                    _dialog!.dismiss();
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

  await _dialog!.show();
}
