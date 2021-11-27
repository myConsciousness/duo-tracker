// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:duo_tracker/src/admob/banner_ad_list.dart';
import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/common_app_bar_title.dart';
import 'package:duo_tracker/src/component/common_card_header_text.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/component/text_with_horizontal_divider.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';

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

  /// The banner ad list
  final _bannerAdList = BannerAdList.newInstance();

  @override
  void dispose() {
    _bannerAdList.dispose();
    super.dispose();
  }

  Map<String, List<Course>> _getCourseMatrix({
    required List<Course> courses,
  }) {
    final courseMatrix = <String, List<Course>>{};

    for (final Course course in courses) {
      if (courseMatrix.containsKey(course.formalFromLanguage)) {
        courseMatrix[course.formalFromLanguage]!.add(course);
      } else {
        courseMatrix[course.formalFromLanguage] = [course];
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
          return Column(
            children: [
              FutureBuilder(
                future: BannerAdUtils.canShow(
                  index: index,
                  interval: 1,
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || !snapshot.data) {
                    return Container();
                  }

                  return BannerAdUtils.createBannerAdWidget(
                    _bannerAdList.loadNewBanner(),
                  );
                },
              ),
              Card(
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
                          CommonCardHeaderText(
                            subtitle: 'Total XP',
                            title: _numericTextFormat.format(
                              _getTotalXp(
                                courses: courses!,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          CommonCardHeaderText(
                            subtitle: 'Total Crowns',
                            title: _numericTextFormat.format(
                              _getTotalCrowns(
                                courses: courses,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      TextWithHorizontalDivider(
                        value: LanguageConverter.toNameWithFormal(
                          languageCode: courses[0].formalFromLanguage,
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
              ),
            ],
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
                            languageCode: course.formalLearningLanguage,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    CommonCardHeaderText(
                      subtitle: 'XP',
                      title: _numericTextFormat.format(course.xp),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CommonCardHeaderText(
                      subtitle: 'Crowns',
                      title: _numericTextFormat.format(course.crowns),
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
        body: CommonNestedScrollView(
          title: const CommonAppBarTitle(title: 'User Dashboard'),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder(
                future:
                    _courseService.findAllOrderByFormalFromLanguageAndXpDesc(),
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
