// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/utils/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/user_column.dart';

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
  String formalLearningLanguage;
  String formalFromLanguage;
  String timezone;
  String timezoneOffset;
  String pictureUrl;
  String plusStatus;
  int lingots;
  int gems;
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
        formalLearningLanguage = '',
        formalFromLanguage = '',
        timezone = '',
        timezoneOffset = '',
        pictureUrl = '',
        plusStatus = '',
        lingots = 0,
        gems = 0,
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
    required this.formalLearningLanguage,
    required this.formalFromLanguage,
    required this.timezone,
    required this.timezoneOffset,
    required this.pictureUrl,
    required this.plusStatus,
    required this.lingots,
    required this.gems,
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
        id: map[UserColumn.id],
        userId: map[UserColumn.userId],
        username: map[UserColumn.username],
        name: map[UserColumn.name],
        bio: map[UserColumn.bio],
        email: map[UserColumn.email],
        location: map[UserColumn.location],
        profileCountry: map[UserColumn.profileCountry],
        inviteUrl: map[UserColumn.inviteUrl],
        currentCourseId: map[UserColumn.currentCourseId],
        learningLanguage: map[UserColumn.learningLanguage],
        fromLanguage: map[UserColumn.fromLanguage],
        formalLearningLanguage: map[UserColumn.formalLearningLanguage],
        formalFromLanguage: map[UserColumn.formalFromLanguage],
        timezone: map[UserColumn.timezone],
        timezoneOffset: map[UserColumn.timezoneOffSet],
        pictureUrl: map[UserColumn.pictureUrl],
        plusStatus: map[UserColumn.plusStatus],
        lingots: map[UserColumn.lingots],
        gems: map[UserColumn.gems],
        totalXp: map[UserColumn.totalXp],
        xpGoal: map[UserColumn.xpGoals],
        weeklyXp: map[UserColumn.weeklyXp],
        monthlyXp: map[UserColumn.monthlyXp],
        xpGoalMetToday: map[UserColumn.xpGoalsMetToday] == BooleanText.true_,
        streak: map[UserColumn.streak],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[UserColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[UserColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [User] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[UserColumn.userId] = userId;
    map[UserColumn.username] = username;
    map[UserColumn.name] = name;
    map[UserColumn.bio] = bio;
    map[UserColumn.email] = email;
    map[UserColumn.location] = location;
    map[UserColumn.profileCountry] = profileCountry;
    map[UserColumn.inviteUrl] = inviteUrl;
    map[UserColumn.currentCourseId] = currentCourseId;
    map[UserColumn.learningLanguage] = learningLanguage;
    map[UserColumn.fromLanguage] = fromLanguage;
    map[UserColumn.formalLearningLanguage] = formalLearningLanguage;
    map[UserColumn.formalFromLanguage] = formalFromLanguage;
    map[UserColumn.timezone] = timezone;
    map[UserColumn.timezoneOffSet] = timezoneOffset;
    map[UserColumn.pictureUrl] = pictureUrl;
    map[UserColumn.plusStatus] = plusStatus;
    map[UserColumn.lingots] = lingots;
    map[UserColumn.gems] = gems;
    map[UserColumn.totalXp] = totalXp;
    map[UserColumn.xpGoals] = xpGoal;
    map[UserColumn.weeklyXp] = weeklyXp;
    map[UserColumn.monthlyXp] = monthlyXp;
    map[UserColumn.xpGoalsMetToday] =
        xpGoalMetToday ? BooleanText.true_ : BooleanText.false_;
    map[UserColumn.streak] = streak;
    map[UserColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[UserColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
