// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';

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
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

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
        streak = 0;

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
        id: map[_ColumnName.id],
        userId: map[_ColumnName.userId],
        username: map[_ColumnName.username],
        name: map[_ColumnName.name],
        bio: map[_ColumnName.bio],
        email: map[_ColumnName.email],
        location: map[_ColumnName.location],
        profileCountry: map[_ColumnName.profileCountry],
        inviteUrl: map[_ColumnName.inviteUrl],
        currentCourseId: map[_ColumnName.currentCourseId],
        learningLanguage: map[_ColumnName.learningLanguage],
        fromLanguage: map[_ColumnName.fromLanguage],
        timezone: map[_ColumnName.timezone],
        timezoneOffset: map[_ColumnName.timezoneOffSet],
        pictureUrl: map[_ColumnName.pictureUrl],
        plusStatus: map[_ColumnName.plusStatus],
        lingots: map[_ColumnName.lingots],
        totalXp: map[_ColumnName.totalXp],
        xpGoal: map[_ColumnName.xpGoals],
        weeklyXp: map[_ColumnName.weeklyXp],
        monthlyXp: map[_ColumnName.monthlyXp],
        xpGoalMetToday: map[_ColumnName.xpGoalsMetToday] == BooleanText.true_,
        streak: map[_ColumnName.streak],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [User] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.userId] = userId;
    map[_ColumnName.username] = username;
    map[_ColumnName.name] = name;
    map[_ColumnName.bio] = bio;
    map[_ColumnName.email] = email;
    map[_ColumnName.location] = location;
    map[_ColumnName.profileCountry] = profileCountry;
    map[_ColumnName.inviteUrl] = inviteUrl;
    map[_ColumnName.currentCourseId] = currentCourseId;
    map[_ColumnName.learningLanguage] = learningLanguage;
    map[_ColumnName.fromLanguage] = fromLanguage;
    map[_ColumnName.timezone] = timezone;
    map[_ColumnName.timezoneOffSet] = timezoneOffset;
    map[_ColumnName.pictureUrl] = pictureUrl;
    map[_ColumnName.plusStatus] = plusStatus;
    map[_ColumnName.lingots] = lingots;
    map[_ColumnName.totalXp] = totalXp;
    map[_ColumnName.xpGoals] = xpGoal;
    map[_ColumnName.weeklyXp] = weeklyXp;
    map[_ColumnName.monthlyXp] = monthlyXp;
    map[_ColumnName.xpGoalsMetToday] =
        xpGoalMetToday ? BooleanText.true_ : BooleanText.false_;
    map[_ColumnName.streak] = streak;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [User] repository.
class _ColumnName {
  static const id = 'ID';
  static const userId = 'USER_ID';
  static const username = 'USERNAME';
  static const name = 'NAME';
  static const bio = 'BIO';
  static const email = 'EMAIL';
  static const location = 'LOCATION';
  static const profileCountry = 'PROFILE_COUNTRY';
  static const inviteUrl = 'INVITE_URL';
  static const currentCourseId = 'CURRENT_COURSE_ID';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const timezone = 'TIMEZONE';
  static const timezoneOffSet = 'TIMEZONE_OFFSET';
  static const pictureUrl = 'PICTURE_URL';
  static const plusStatus = 'PLUS_STATUS';
  static const lingots = 'LINGOTS';
  static const totalXp = 'TOTAL_XP';
  static const xpGoals = 'XP_GOAL';
  static const weeklyXp = 'WEEKLY_XP';
  static const monthlyXp = 'MONTHLY_XP';
  static const xpGoalsMetToday = 'XP_GOAL_MET_TODAY';
  static const streak = 'STREAK';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
