// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/admob/interstitial_ad_utils.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/const/date_format_pattern.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/preference/interstitial_ad_shared_preferences_key.dart';
import 'package:flutter/material.dart';

late AwesomeDialog _dialog;

/// The date format pattern
late DateFormatPattern _dateFormatPattern;

Future<T?> showSelectDateTimeFormatDialog<T>({
  required BuildContext context,
}) async {
  final dateFotmatCode = await CommonSharedPreferencesKey.dateFormat.getInt();
  _dateFormatPattern = DateFormatPatternExt.toEnum(code: dateFotmatCode);

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
                const Center(
                  child: Text(
                    'Select Date Format',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonTwoGridsRadioListTile(
                  label: 'Format Pattern',
                  dataSource: const {
                    'yyyy/MM/dd': DateFormatPattern.yyyymmdd,
                    'yyyy/dd/MM': DateFormatPattern.yyyyddmm,
                    'dd/MM/yyyyy': DateFormatPattern.ddmmyyyy,
                    'MM/dd/yyyy': DateFormatPattern.mmddyyyy,
                  },
                  groupValue: _dateFormatPattern,
                  onChanged: (value) async {
                    await CommonSharedPreferencesKey.dateFormat.setInt(
                      (value as DateFormatPattern).code,
                    );

                    setState(() {
                      _dateFormatPattern = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedButton(
                    isFixedHeight: false,
                    text: 'Apply',
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    pressEvent: () async {
                      _dialog.dismiss();

                      await InterstitialAdUtils.showInterstitialAd(
                        sharedPreferencesKey:
                            InterstitialAdSharedPreferencesKey.countFilterWords,
                      );
                    },
                  ),
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
