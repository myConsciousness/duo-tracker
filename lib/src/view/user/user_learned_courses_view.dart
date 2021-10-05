// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/text_with_horizontal_divider.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class UserLearnedCoursesView extends StatefulWidget {
  const UserLearnedCoursesView({Key? key}) : super(key: key);

  @override
  _UserLearnedCoursesViewState createState() => _UserLearnedCoursesViewState();
}

class _UserLearnedCoursesViewState extends State<UserLearnedCoursesView> {
  /// The course service
  final _courseService = CourseService.getInstance();

  /// The format for numeric text
  final _numericTextFormat = NumberFormat('#,###');

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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
                bottom: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCardHeaderText(
                        title: _numericTextFormat.format(
                          _getTotalXp(
                            courses: courses!,
                          ),
                        ),
                        subTitle: 'Total XP',
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      _buildCardHeaderText(
                        title: _numericTextFormat.format(
                          _getTotalCrowns(
                            courses: courses,
                          ),
                        ),
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
                ],
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
            elevation: 0,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
          );
        },
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder(
                future: _courseService.findAllOrderByFromLanguageAndXpDesc(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Loading();
                  }

                  return _buildLearnedCourseCards(courses: snapshot.data);
                },
              ),
            ),
          ),
        ),
      );
}
