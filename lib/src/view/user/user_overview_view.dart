// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/charts/radical_bar_chart.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/dialog/select_score_goals_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:duo_tracker/src/repository/model/chart_data_source_mode.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/chart_service.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/utils/learning_score_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UserOverviewView extends StatefulWidget {
  const UserOverviewView({Key? key}) : super(key: key);

  @override
  _UserOverviewViewState createState() => _UserOverviewViewState();
}

class _UserOverviewViewState extends State<UserOverviewView> {
  /// The chart service
  final _chartService = ChartService.getInstance();

  /// The goal of daily xp
  late double _goalDailyXp;

  /// The goal of monthly xp
  late double _goalMonthlyXp;

  /// The goal of streak
  late double _goalStreak;

  /// The goal of weekly xp
  late double _goalWeeklyXp;

  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

  /// The user service
  final _userService = UserService.getInstance();

  /// The banner ad
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _asyncInitState();
  }

  BannerAd _loadBannerAd() {
    _bannerAd = BannerAdUtils.loadBannerAd();
    return _bannerAd!;
  }

  Future<void> _asyncInitState() async {
    await _refreshScoreGoals();
    super.setState(() {});
  }

  Future<void> _refreshScoreGoals() async {
    _goalDailyXp = await CommonSharedPreferencesKey.scoreGoalsDailyXp.getDouble(
      defaultValue: 30.0,
    );
    _goalWeeklyXp =
        await CommonSharedPreferencesKey.scoreGoalsWeeklyXp.getDouble(
      defaultValue: 250.0,
    );
    _goalMonthlyXp =
        await CommonSharedPreferencesKey.scoreGoalsMonthlyXp.getDouble(
      defaultValue: 4000.0,
    );
    _goalStreak = await CommonSharedPreferencesKey.scoreGoalsStreak.getDouble(
      defaultValue: 14.0,
    );
  }

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
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 13,
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

  Future<List<ChartDataSource>> _computeLearningScoreRatio() async {
    final dailyXpGoal =
        await CommonSharedPreferencesKey.scoreGoalsDailyXp.getDouble(
      defaultValue: 30.0,
    );
    final weeklyXpGoal =
        await CommonSharedPreferencesKey.scoreGoalsWeeklyXp.getDouble(
      defaultValue: 250.0,
    );
    final monthlyXpGoal =
        await CommonSharedPreferencesKey.scoreGoalsMonthlyXp.getDouble(
      defaultValue: 4000.0,
    );
    final streakGoal =
        await CommonSharedPreferencesKey.scoreGoalsStreak.getDouble(
      defaultValue: 14.0,
    );

    final userId = await CommonSharedPreferencesKey.userId.getString();

    return await _chartService.computeLearningScoreRatioByUserIdAndTargets(
      userId: userId,
      targetXpPerDay: dailyXpGoal,
      targetWeeklyXp: weeklyXpGoal,
      targetMontlyXp: monthlyXpGoal,
      targetStreak: streakGoal,
    );
  }

  Widget _buildRadicalBarChart({
    required User user,
  }) =>
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: FutureBuilder(
          future: _computeLearningScoreRatio(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: BannerAdUtils.canShow(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Loading();
                    }

                    if (!snapshot.data) {
                      return Container();
                    }

                    return BannerAdUtils.createBannerAdWidget(_loadBannerAd());
                  },
                ),
                RadicalBarChart(
                  chartTitle: ChartTitle(
                    text: 'Goals and Progress',
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerObject: CircleAvatar(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    radius: 50,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  chartDataSources: snapshot.data,
                ),
                _buildGoalCard(
                  user: user,
                  achievementScore: _getAchievementScore(
                    chartDataSources: snapshot.data,
                  ),
                ),
              ],
            );
          },
        ),
      );

  int _getAchievementScore({
    required List<ChartDataSource> chartDataSources,
  }) {
    int score = 0;
    for (final ChartDataSource chartDataSources in chartDataSources) {
      score += LearningScoreConverter.toScore(achievement: chartDataSources.y);
    }

    return score;
  }

  Widget _buildGoalCard({
    required User user,
    required int achievementScore,
  }) =>
      Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: <Widget>[
                  _buildCardText(
                    title: 'Score',
                    subTitle: '$achievementScore / 160',
                  ),
                  _buildCardText(
                    title: 'Grade',
                    subTitle: LearningScoreConverter.toGrade(
                      score: achievementScore,
                    ),
                  ),
                ],
              ),
              const CommonDivider(),
              Row(
                children: <Widget>[
                  _buildCardText(
                    title: 'Daily XP',
                    subTitle: _numericTextFormat.format(_goalDailyXp),
                  ),
                  _buildCardText(
                    title: 'Weekly XP',
                    subTitle: _numericTextFormat.format(_goalWeeklyXp),
                  ),
                  _buildCardText(
                    title: 'Monthly XP',
                    subTitle: _numericTextFormat.format(_goalMonthlyXp),
                  ),
                  _buildCardText(
                    title: 'Streak',
                    subTitle: _numericTextFormat.format(_goalStreak),
                  ),
                ],
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
      );

  Widget _buildStatusCard({
    required User user,
  }) =>
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child: Row(
              children: <Widget>[
                _buildCardText(
                  title: 'Learning',
                  subTitle: LanguageConverter.toNameWithFormal(
                    languageCode: user.learningLanguage,
                  ),
                ),
                _buildCardText(
                  title: 'From',
                  subTitle: LanguageConverter.toNameWithFormal(
                    languageCode: user.fromLanguage,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSummaryCard({
    required User user,
  }) =>
      Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child: Column(
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
                      title: 'Daily XP',
                      subTitle: _numericTextFormat.format(user.weeklyXp / 7.0),
                    ),
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
            ),
          ),
        ),
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
    await showLoadingDialog(
      context: context,
      title: 'Updating API Config',
      future: DuolingoApiUtils.refreshVersionInfo(context: context),
    );

    await showLoadingDialog(
      context: context,
      title: 'Updating User Information',
      future: DuolingoApiUtils.refreshUser(context: context),
    );

    await showLoadingDialog(
      context: context,
      title: 'Updating Learned Words',
      future: DuolingoApiUtils.synchronizeLearnedWords(context: context),
    );

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
          buttonSize: 50,
          childrenButtonSize: 50,
          tooltip: 'Show Actions',
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.userAlt,
              label: 'Switch Account',
              onTap: () async {
                final authenticated = await showAuthDialog(
                  context: context,
                  dismissOnTouchOutside: true,
                );

                if (authenticated) {
                  await _syncLearnedWords();
                }
              },
            ),
            _buildSpeedDialChild(
              icon: FontAwesomeIcons.dumbbell,
              label: 'Adjust Goals',
              onTap: () async {
                await showSelectScoreGoalsDialog(context: context);
                await _refreshScoreGoals();
                super.setState(() {});
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      _buildStatusCard(user: user),
                      _buildSummaryCard(user: user),
                      _buildRadicalBarChart(user: user),
                      const SizedBox(
                        height: 30,
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