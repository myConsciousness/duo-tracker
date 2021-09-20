// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_radio_list_tile.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';

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

extension MatchPatternExt on MatchPattern {
  int get code {
    switch (this) {
      case MatchPattern.partial:
        return 0;
      case MatchPattern.exact:
        return 1;
      case MatchPattern.prefix:
        return 2;
      case MatchPattern.suffix:
        return 3;
    }
  }

  static MatchPattern toEnum({required final int code}) {
    for (final MatchPattern matchPattern in MatchPattern.values) {
      if (code == matchPattern.code) {
        return matchPattern;
      }
    }

    return MatchPattern.prefix;
  }
}

late AwesomeDialog _dialog;
late MatchPattern _matchPattern;

Future<T?> showSelectSearchMethodDialog<T>({
  required BuildContext context,
}) async {
  final matchPatternCode =
      await CommonSharedPreferencesKey.matchPattern.getInt();
  _matchPattern = MatchPatternExt.toEnum(code: matchPatternCode);

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
                        .setInt(_matchPattern.code);
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
