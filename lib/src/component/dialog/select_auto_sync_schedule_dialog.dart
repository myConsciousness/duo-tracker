// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/schedule_cycle_unit.dart';
import 'package:duo_tracker/src/component/dialog/warning_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

late AwesomeDialog _dialog;

/// The schedule cycle unit
late ScheduleCycleUnit _cycleUnit;

/// The auto sync cycle count
late int _autoSyncCycleCount;

/// The datetime last auto synced
late DateTime _lastAutoSyncedAt;

/// The auto sync cycle
final _autoSyncCycle = TextEditingController();

/// The datetime format
final _datetimeFormat = DateFormat('yyyy/MM/dd HH:mm');

Future<T?> showSelectAutoSyncScheduleDialog<T>({
  required BuildContext context,
  required Function onSubmitted,
}) async {
  final cycleUnitCode =
      await CommonSharedPreferencesKey.autoSyncCycleUnit.getInt();

  _cycleUnit = ScheduleCycleUnitExt.toEnum(code: cycleUnitCode);
  _autoSyncCycleCount =
      await CommonSharedPreferencesKey.autoSyncCycle.getInt(defaultValue: 1);
  _autoSyncCycle.text = '$_autoSyncCycleCount';

  _lastAutoSyncedAt = DateTime.fromMillisecondsSinceEpoch(
    await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview.getInt(),
  );

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
                    'Auto Sync Schedule',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                _buildNextAutoSyncDatetimeSection(
                  context: context,
                ),
                const SizedBox(
                  height: 25,
                ),
                _buildCycleUnitSection(
                  setState: setState,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildCycleSection(
                  context: context,
                  setState: setState,
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Apply',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    await CommonSharedPreferencesKey.autoSyncCycleUnit
                        .setInt(_cycleUnit.code);
                    await CommonSharedPreferencesKey.autoSyncCycle
                        .setInt(_autoSyncCycleCount);

                    onSubmitted.call();

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
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );

Widget _buildCycleUnitSection({
  required Function setState,
}) =>
    CommonTwoGridsRadioListTile(
      label: 'Cycle Unit',
      dataSource: const {
        'Day': ScheduleCycleUnit.day,
        'Hour': ScheduleCycleUnit.hour,
      },
      groupValue: _cycleUnit,
      onChanged: (value) {
        setState(() {
          _cycleUnit = value;
        });
      },
    );

Widget _buildCycleSection({
  required BuildContext context,
  required Function setState,
}) =>
    Column(
      children: [
        Center(
          child: Text(
            'Cycle',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Icon(FontAwesomeIcons.minus),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondaryVariant,
                ),
                onPressed: () async {
                  if (_autoSyncCycleCount - 1 < 1) {
                    await showWarningDialog(
                      context: context,
                      title: 'Invalid schedule',
                      content:
                          'The auto sync cycle should be a number greater than 0.',
                    );

                    return;
                  }

                  setState(() {
                    _autoSyncCycleCount--;
                    _autoSyncCycle.text = '$_autoSyncCycleCount';
                  });
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: _autoSyncCycle,
                enabled: false,
                readOnly: true,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                child: const Icon(FontAwesomeIcons.plus),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondaryVariant,
                ),
                onPressed: () {
                  setState(() {
                    _autoSyncCycleCount++;
                    _autoSyncCycle.text = '$_autoSyncCycleCount';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );

Widget _buildNextAutoSyncDatetimeSection({
  required BuildContext context,
}) =>
    Column(
      children: [
        Center(
          child: Text(
            'Next Auto Sync At',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(_datetimeFormat.format(_computeNextAutoSync())),
        ),
      ],
    );

DateTime _computeNextAutoSync() {
  switch (_cycleUnit) {
    case ScheduleCycleUnit.day:
      return _lastAutoSyncedAt.add(Duration(days: _autoSyncCycleCount));
    case ScheduleCycleUnit.hour:
      return DateTime.now().add(Duration(hours: _autoSyncCycleCount));
  }
}
