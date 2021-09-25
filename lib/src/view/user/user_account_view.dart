// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/text_with_horizontal_divider.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({Key? key}) : super(key: key);

  @override
  _UserAccountViewState createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  /// The course service
  final _courseService = CourseService.getInstance();

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

  Map<String, List<Course>> _getCourseMatrix({
    required List<Course> courses,
  }) {
    final courseMatrix = <String, List<Course>>{};

    for (final Course course in courses) {
      if (courseMatrix.containsKey(course.fromLanguage)) {
        courseMatrix[course.fromLanguage]!.add(course);
      } else {
        courseMatrix[course.fromLanguage] = [course];
      }
    }

    return courseMatrix;
  }

  Widget _buildLearnedCourseCards({
    required List<Course> courses,
  }) {
    final courseMatrix = _getCourseMatrix(courses: courses);
    final keys = courseMatrix.keys.toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLearnedCourseParentSection(
          courseMatrix: courseMatrix,
          keys: keys,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildLearnedCourseParentSection({
    required Map<String, List<Course>> courseMatrix,
    required List<String> keys,
  }) =>
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: courseMatrix.length,
        itemBuilder: (BuildContext context, int index) {
          final courses = courseMatrix[keys[index]];
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCardHeaderText(
                        title: _numericTextFormat.format(_getTotalXp(
                          courses: courses!,
                        )),
                        subTitle: 'Total XP',
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      _buildCardHeaderText(
                        title: _numericTextFormat.format(_getTotalCrowns(
                          courses: courses,
                        )),
                        subTitle: 'Total Crowns',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  TextWithHorizontalDivider(
                    value: LanguageConverter.toNameWithFormal(
                      languageCode: courses[0].fromLanguage,
                    ),
                    fontSize: 15,
                    textColor: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  _buildLearnedCourseChildSection(
                    courses: courses,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const CommonDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
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
        },
      );

  Widget _buildLearnedCourseChildSection({
    required List<Course> courses,
  }) =>
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          final course = courses[index];
          return Card(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          LanguageConverter.toNameWithFormal(
                            languageCode: course.learningLanguage,
                          ),
                        ),
                      ),
                    ),
                    _buildCardHeaderText(
                      title: _numericTextFormat.format(course.xp),
                      subTitle: 'XP',
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    _buildCardHeaderText(
                      title: _numericTextFormat.format(course.crowns),
                      subTitle: 'Crowns',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
                bottom: Radius.circular(30),
              ),
            ),
          );
        },
      );

  Text _buildTextSecondaryColor({
    required String text,
    required double fontSize,
    double opacity = 1.0,
    FontWeight fontWeight = FontWeight.normal,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withOpacity(opacity),
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );

  Text _buildText({
    required String text,
    required double fontSize,
    double opacity = 1.0,
    bool boldText = false,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(opacity),
          fontSize: fontSize,
          fontWeight: boldText ? FontWeight.bold : FontWeight.normal,
        ),
      );

  Widget _buildCardHeaderText({
    required String title,
    required String subTitle,
  }) =>
      Column(
        children: [
          _buildTextSecondaryColor(
            text: subTitle,
            fontSize: 12,
          ),
          _buildText(
            text: title,
            fontSize: 14,
          ),
        ],
      );

  Widget _buildCircleAvatar({
    required User user,
  }) =>
      CircleAvatar(
        child: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
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

  int _getTotalXp({required List<Course> courses}) {
    int totalXp = 0;
    for (final Course course in courses) {
      totalXp += course.xp;
    }

    return totalXp;
  }

  int _getTotalCrowns({required List<Course> courses}) {
    int totalCrowns = 0;
    for (final Course course in courses) {
      totalCrowns += course.crowns;
    }

    return totalCrowns;
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
                      _buildCircleAvatar(user: user),
                      const SizedBox(
                        height: 25,
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
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: _courseService
                            .findAllOrderByFromLanguageAndXpDesc(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Loading();
                          }

                          return _buildLearnedCourseCards(
                              courses: snapshot.data);
                        },
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
