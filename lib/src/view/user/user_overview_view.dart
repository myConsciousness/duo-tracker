// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/charts/radical_bar_chart.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UserOverviewView extends StatefulWidget {
  const UserOverviewView({Key? key}) : super(key: key);

  @override
  _UserOverviewViewState createState() => _UserOverviewViewState();
}

class _UserOverviewViewState extends State<UserOverviewView> {
  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

  /// The user service
  final _userService = UserService.getInstance();

  Widget _buildCardText({
    required String title,
    required String subTitle,
  }) =>
      Expanded(
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          ],
        ),
      );

  Future<User> _findUser() async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    return await _userService.findByUserId(userId: userId);
  }

  Widget _buildCircleChart({
    required User user,
  }) =>
      RadicalBarChart(
        centerObject: CircleAvatar(
          child: Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
        ),
      );

  Widget _buildMainSummaryCard({
    required User user,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              _buildCardText(
                title: 'Lingots',
                subTitle: _numericTextFormat.format(user.lingots),
              ),
              _buildCardText(
                title: 'Gems',
                subTitle: _numericTextFormat.format(user.gems),
              ),
              _buildCardText(
                title: 'XP Goal',
                subTitle: '${user.xpGoal}',
              ),
              _buildCardText(
                title: 'Streak',
                subTitle: '${user.streak}',
              ),
            ],
          ),
          const CommonDivider(),
          Row(
            children: <Widget>[
              _buildCardText(
                title: 'Weekly XP',
                subTitle: _numericTextFormat.format(user.weeklyXp),
              ),
              _buildCardText(
                title: 'Monthly XP',
                subTitle: _numericTextFormat.format(user.monthlyXp),
              ),
              _buildCardText(
                title: 'Total XP',
                subTitle: _numericTextFormat.format(user.totalXp),
              ),
            ],
          ),
        ],
      );

  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) =>
      SpeedDialChild(
        child: Icon(
          icon,
          size: 19,
        ),
        label: label,
        onTap: onTap,
      );

  Future<void> _syncLearnedWords() async {
    if (!await DuolingoApiUtils.refreshVersionInfo(context: context)) {
      return;
    }

    if (!await DuolingoApiUtils.refreshUser(context: context)) {
      return;
    }

    if (!await DuolingoApiUtils.synchronizeLearnedWords(context: context)) {
      return;
    }

    super.setState(() {});

    await CommonSharedPreferencesKey.datetimeLastAutoSyncedOverview.setInt(
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: SpeedDial(
          renderOverlay: true,
          switchLabelPosition: true,
          buttonSize: 40,
          childrenButtonSize: 40,
          tooltip: 'Show Actions',
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.userAlt,
              label: 'Switch Account',
              onTap: () async {
                await showAuthDialog(
                  context: context,
                );

                await showLoadingDialog(
                  context: context,
                  title: 'Updating Learned Words',
                  future: _syncLearnedWords(),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: _findUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                }

                final User user = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      _buildCircleChart(user: user),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 22,
                          ),
                          child: _buildMainSummaryCard(user: user),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
}
