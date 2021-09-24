// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({Key? key}) : super(key: key);

  @override
  _UserAccountViewState createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  /// The course service
  final _courseService = CourseService.getInstance();

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
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 16,
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
                    Text(
                      LanguageConverter.toNameWithFormal(
                        languageCode: courses![0].fromLanguage,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, int index) {
                        final course = courses[index];
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              LanguageConverter.toNameWithFormal(
                                languageCode: course.learningLanguage,
                              ),
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
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildCircleAvatar({
    required User user,
  }) =>
      CircleAvatar(
        child: Text(
          user.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
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
                subTitle: '${user.lingots}',
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
                subTitle: '${user.weeklyXp}',
              ),
              _buildCardText(
                title: 'Monthly XP',
                subTitle: '${user.monthlyXp}',
              ),
              _buildCardText(
                title: 'Total XP',
                subTitle: '${user.totalXp}',
              ),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
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
                            .findByGroupByFromLanguageAndLearningLanguage(),
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
