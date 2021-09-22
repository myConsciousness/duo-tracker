// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/user_column_name.dart';

class User {
  int id = -1;
  String userId;
  String username;
  String name;
  String bio;
  String email;
  String location;
  String profileCountry;
  String inviteUrl;
  String currentCourseId;
  String learningLanguage;
  String fromLanguage;
  String timezone;
  String timezoneOffset;
  String pictureUrl;
  String plusStatus;
  int lingots;
  int totalXp;
  int xpGoal;
  int weeklyXp;
  int monthlyXp;
  bool xpGoalMetToday;
  int streak;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [User].
  User.empty()
      : _empty = true,
        userId = '',
        username = '',
        name = '',
        bio = '',
        email = '',
        location = '',
        profileCountry = '',
        inviteUrl = '',
        currentCourseId = '',
        learningLanguage = '',
        fromLanguage = '',
        timezone = '',
        timezoneOffset = '',
        pictureUrl = '',
        plusStatus = '',
        lingots = 0,
        totalXp = 0,
        xpGoal = 0,
        weeklyXp = 0,
        monthlyXp = 0,
        xpGoalMetToday = false,
        streak = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [User] based on the parameters.
  User.from({
    this.id = -1,
    required this.userId,
    required this.username,
    required this.name,
    required this.bio,
    required this.email,
    required this.location,
    required this.profileCountry,
    required this.inviteUrl,
    required this.currentCourseId,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.timezone,
    required this.timezoneOffset,
    required this.pictureUrl,
    required this.plusStatus,
    required this.lingots,
    required this.totalXp,
    required this.xpGoal,
    required this.weeklyXp,
    required this.monthlyXp,
    required this.xpGoalMetToday,
    required this.streak,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [User] based on the [map] passed as an argument.
  factory User.fromMap(Map<String, dynamic> map) => User.from(
        id: map[UserColumnName.id],
        userId: map[UserColumnName.userId],
        username: map[UserColumnName.username],
        name: map[UserColumnName.name],
        bio: map[UserColumnName.bio],
        email: map[UserColumnName.email],
        location: map[UserColumnName.location],
        profileCountry: map[UserColumnName.profileCountry],
        inviteUrl: map[UserColumnName.inviteUrl],
        currentCourseId: map[UserColumnName.currentCourseId],
        learningLanguage: map[UserColumnName.learningLanguage],
        fromLanguage: map[UserColumnName.fromLanguage],
        timezone: map[UserColumnName.timezone],
        timezoneOffset: map[UserColumnName.timezoneOffSet],
        pictureUrl: map[UserColumnName.pictureUrl],
        plusStatus: map[UserColumnName.plusStatus],
        lingots: map[UserColumnName.lingots],
        totalXp: map[UserColumnName.totalXp],
        xpGoal: map[UserColumnName.xpGoals],
        weeklyXp: map[UserColumnName.weeklyXp],
        monthlyXp: map[UserColumnName.monthlyXp],
        xpGoalMetToday:
            map[UserColumnName.xpGoalsMetToday] == BooleanText.true_,
        streak: map[UserColumnName.streak],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[UserColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[UserColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [User] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[UserColumnName.userId] = userId;
    map[UserColumnName.username] = username;
    map[UserColumnName.name] = name;
    map[UserColumnName.bio] = bio;
    map[UserColumnName.email] = email;
    map[UserColumnName.location] = location;
    map[UserColumnName.profileCountry] = profileCountry;
    map[UserColumnName.inviteUrl] = inviteUrl;
    map[UserColumnName.currentCourseId] = currentCourseId;
    map[UserColumnName.learningLanguage] = learningLanguage;
    map[UserColumnName.fromLanguage] = fromLanguage;
    map[UserColumnName.timezone] = timezone;
    map[UserColumnName.timezoneOffSet] = timezoneOffset;
    map[UserColumnName.pictureUrl] = pictureUrl;
    map[UserColumnName.plusStatus] = plusStatus;
    map[UserColumnName.lingots] = lingots;
    map[UserColumnName.totalXp] = totalXp;
    map[UserColumnName.xpGoals] = xpGoal;
    map[UserColumnName.weeklyXp] = weeklyXp;
    map[UserColumnName.monthlyXp] = monthlyXp;
    map[UserColumnName.xpGoalsMetToday] =
        xpGoalMetToday ? BooleanText.true_ : BooleanText.false_;
    map[UserColumnName.streak] = streak;
    map[UserColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[UserColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
