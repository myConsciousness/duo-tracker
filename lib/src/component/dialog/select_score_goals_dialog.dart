// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

late AwesomeDialog _dialog;
late double _selectedDailyXp;
late double _selectedWeeklyXp;
late double _selectedMonthlyXp;
late double _selectedStreak;

Future<T?> showSelectScoreGoalsDialog<T>({
  required BuildContext context,
}) async {
  _selectedDailyXp =
      await CommonSharedPreferencesKey.scoreGoalsDailyXp.getDouble(
    defaultValue: 30.0,
  );
  _selectedWeeklyXp =
      await CommonSharedPreferencesKey.scoreGoalsWeeklyXp.getDouble(
    defaultValue: 250.0,
  );
  _selectedMonthlyXp =
      await CommonSharedPreferencesKey.scoreGoalsMonthlyXp.getDouble(
    defaultValue: 4000.0,
  );
  _selectedStreak = await CommonSharedPreferencesKey.scoreGoalsStreak.getDouble(
    defaultValue: 14.0,
  );

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
                    'Adjust Goals',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildSfSlider(
                  context: context,
                  title: 'Daily XP',
                  value: _selectedDailyXp,
                  goalMin: 10.0,
                  goalMax: 300.0,
                  interval: 50,
                  onChanged: (value) {
                    setState(() {
                      _selectedDailyXp = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildSfSlider(
                  context: context,
                  title: 'Weekly XP',
                  value: _selectedWeeklyXp,
                  goalMin: 100.0,
                  goalMax: 2500.0,
                  interval: 700,
                  onChanged: (value) {
                    setState(() {
                      _selectedWeeklyXp = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildSfSlider(
                  context: context,
                  title: 'Monthly XP',
                  value: _selectedMonthlyXp,
                  goalMin: 500.0,
                  goalMax: 10000.0,
                  interval: 2000,
                  onChanged: (value) {
                    setState(() {
                      _selectedMonthlyXp = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildSfSlider(
                  context: context,
                  title: 'Streak',
                  value: _selectedStreak,
                  goalMin: 10.0,
                  goalMax: 3000.0,
                  interval: 1000,
                  onChanged: (value) {
                    setState(() {
                      _selectedStreak = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Apply',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    await CommonSharedPreferencesKey.scoreGoalsDailyXp
                        .setDouble(_selectedDailyXp);
                    await CommonSharedPreferencesKey.scoreGoalsWeeklyXp
                        .setDouble(_selectedWeeklyXp);
                    await CommonSharedPreferencesKey.scoreGoalsMonthlyXp
                        .setDouble(_selectedMonthlyXp);
                    await CommonSharedPreferencesKey.scoreGoalsStreak
                        .setDouble(_selectedStreak);

                    _dialog.dismiss();
                  },
                ),
                const SizedBox(
                  height: 5,
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

Widget _buildSfSlider({
  required BuildContext context,
  required String title,
  required double value,
  required double goalMin,
  required double goalMax,
  required double interval,
  required void Function(dynamic)? onChanged,
}) =>
    Column(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        SfSlider(
          min: goalMin,
          max: goalMax,
          value: value,
          showTicks: true,
          showLabels: true,
          interval: interval,
          enableTooltip: true,
          minorTicksPerInterval: 1,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );