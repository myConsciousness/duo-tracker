// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:flutter/material.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({Key? key}) : super(key: key);

  @override
  _UserAccountViewState createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  /// The user service
  final _userService = UserService.getInstance();

  /// The course service
  final _courseService = CourseService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      radius: 50,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryVariant,
                    ),
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
                        child: Column(
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
                            _divider,
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
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: _courseService.findAll(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Loading();
                        }

                        final List<Course> courses = snapshot.data;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text(courses[index].title),
                              ),
                            );
                          },
                        );
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

  Divider get _divider => Divider(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      );

  Future<User> _findUser() async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    return await _userService.findByUserId(userId: userId);
  }
}
