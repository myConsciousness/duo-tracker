// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/http_status.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/model/skill_model.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/repository/service/skill_serviced.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:flutter/material.dart';

class UserApiAdapter extends ApiAdapter {
  /// The course service
  final _courseService = CourseService.getInstance();

  /// The skill service
  final _skillService = SkillService.getInstance();

  /// The user service
  final _userService = UserService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required BuildContext context,
    final params = const <String, String>{},
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final response =
        await DuolingoApi.user.request.send(params: {'userId': userId});
    final httpStatus = HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(utf8.decode(response.body.runes.toList()));

      await _updateUser(userId: userId, json: jsonMap);
      await _refreshCourse(json: jsonMap);
      await _refreshSkill(json: jsonMap);

      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.user,
      errorType: ErrorType.unknown,
    );
  }

  Future<void> _updateUser({
    required String userId,
    required Map<String, dynamic> json,
  }) async {
    final learningLanguage = json['trackingProperties']['learning_language'];
    final fromLanguage = json['fromLanguage'];

    final now = DateTime.now();
    await _userService.replaceByUserId(
      user: User.from(
        userId: userId,
        username: json['username'] ?? '',
        name: json['name'] ?? '',
        bio: json['bio'] ?? '',
        email: json['email'] ?? '',
        location: json['location'] ?? '',
        profileCountry: json['profileCountry'] ?? '',
        inviteUrl: json['inviteURL'] ?? '',
        currentCourseId: json['currentCourseId'] ?? '',
        learningLanguage: learningLanguage,
        fromLanguage: fromLanguage,
        timezone: json['timezone'] ?? '',
        timezoneOffset: json['timezoneOffset'] ?? '',
        pictureUrl: json['picture'] ?? '',
        plusStatus: json['plusStatus'] ?? '',
        lingots: json['lingots'],
        totalXp: json['totalXp'],
        xpGoal: json['xpGoal'],
        weeklyXp: json['weeklyXp'],
        monthlyXp: json['monthlyXp'],
        xpGoalMetToday: json['xpGoalMetToday'],
        streak: json['streak'],
        createdAt: now,
        updatedAt: now,
      ),
    );

    await CommonSharedPreferencesKey.currentLearningLanguage
        .setString(learningLanguage);
    await CommonSharedPreferencesKey.currentFromLanguage
        .setString(fromLanguage);
  }

  Future<void> _refreshCourse({
    required Map<String, dynamic> json,
  }) async {
    await _courseService.deleteAll();

    final now = DateTime.now();
    for (final Map<String, dynamic> course in json['courses']) {
      _courseService.insert(
        Course.from(
          courseId: course['id'],
          title: course['title'],
          learningLanguage: course['learningLanguage'],
          fromLanguage: course['fromLanguage'],
          xp: course['xp'],
          crowns: course['crowns'],
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  Future<void> _refreshSkill({
    required Map<String, dynamic> json,
  }) async {
    await _skillService.deleteAll();

    final now = DateTime.now();
    for (final List<dynamic> skillsInternal in json['currentCourse']
        ['skills']) {
      for (final Map<String, dynamic> skill in skillsInternal) {
        _skillService.insert(
          Skill.from(
            skillId: skill['id'],
            name: skill['name'],
            shortName: skill['shortName'],
            urlName: skill['urlName'],
            iconId: skill['iconId'],
            lessons: skill['lessons'],
            strength: skill['strength'] ?? 0,
            lastLessonPerfect: skill['lastLessonPerfect'],
            finishedLevels: skill['finishedLevels'],
            levels: skill['levels'],
            tipsAndNotes: skill['tipsAndNotes'] ?? '',
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }
  }
}
