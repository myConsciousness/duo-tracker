// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_radio_list_tile.dart';
import 'package:duo_tracker/src/const/date_format_pattern.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late AwesomeDialog _dialog;

/// The date format pattern
late DateFormatPattern _dateFormatPattern;

Future<T?> showSelectDateTimeFormatDialog<T>({
  required BuildContext context,
  required Function onSubmitted,
}) async {
  final dateFotmatCode = await CommonSharedPreferencesKey.dateFormat.getInt();
  _dateFormatPattern = DateFormatPatternExt.toEnum(code: dateFotmatCode);

  _dialog = _buildDialog(
    context: context,
    onSubmitted: onSubmitted,
  );

  await _dialog.show();
}

AwesomeDialog _buildDialog({
  required BuildContext context,
  required Function onSubmitted,
}) =>
    AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.QUESTION,
      btnOkColor: Theme.of(context).colorScheme.secondary,
      body: _buildDialogBody(
        onSubmitted: onSubmitted,
      ),
    );

Widget _buildDialogBody({
  required Function onSubmitted,
}) =>
    StatefulBuilder(
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
                _buildRadioFormatPatternSection(
                  setState: setState,
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
                      await CommonSharedPreferencesKey.dateFormat.setInt(
                        _dateFormatPattern.code,
                      );

                      onSubmitted.call();
                      _dialog.dismiss();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

Map<String, DateFormatPattern> _buildDateFormatDataSource() {
  final dataSource = <String, DateFormatPattern>{};

  final now = DateTime.now();
  for (final dateFormatPattern in DateFormatPattern.values) {
    final dateFormat = DateFormat(dateFormatPattern.pattern);
    dataSource['${dateFormatPattern.pattern} (${dateFormat.format(now)})'] =
        dateFormatPattern;
  }

  return dataSource;
}

Widget _buildRadioFormatPatternSection({
  required Function setState,
}) =>
    CommonRadioListTile(
      label: 'Format Pattern',
      dataSource: _buildDateFormatDataSource(),
      groupValue: _dateFormatPattern,
      onChanged: (value) async {
        await CommonSharedPreferencesKey.dateFormat.setInt(
          (value as DateFormatPattern).code,
        );

        setState(() {
          _dateFormatPattern = value;
        });
      },
    );
