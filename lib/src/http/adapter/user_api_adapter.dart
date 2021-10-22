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
import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/repository/service/skill_service.dart';
import 'package:duo_tracker/src/repository/service/tip_and_note_service.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserApiAdapter extends ApiAdapter {
  /// The max length of tip and note content
  static const _maxLengthTipAndNoteContent = 100;

  /// The course service
  final _courseService = CourseService.getInstance();

  /// The skill service
  final _skillService = SkillService.getInstance();

  /// The user service
  final _userService = UserService.getInstance();

  /// The tip and note service
  final _tipAndNoteService = TipAndNoteService.getInstance();

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
        formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
          languageCode: learningLanguage,
        ),
        formalFromLanguage: LanguageConverter.toFormalLanguageCode(
          languageCode: fromLanguage,
        ),
        timezone: json['timezone'] ?? '',
        timezoneOffset: json['timezoneOffset'] ?? '',
        pictureUrl: json['picture'] ?? '',
        plusStatus: json['plusStatus'] ?? '',
        lingots: json['lingots'],
        gems: json['gems'],
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

    final courses = <Course>[];
    final now = DateTime.now();
    for (final Map<String, dynamic> course in json['courses']) {
      courses.add(
        Course.from(
          courseId: course['id'],
          title: course['title'],
          formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
            languageCode: course['learningLanguage'],
          ),
          formalFromLanguage: LanguageConverter.toFormalLanguageCode(
            languageCode: course['fromLanguage'],
          ),
          xp: course['xp'],
          crowns: course['crowns'],
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    await _courseService.insertAll(courses: courses);
  }

  Future<void> _refreshSkill({
    required Map<String, dynamic> json,
  }) async {
    await _skillService.deleteAll();

    final userId = await CommonSharedPreferencesKey.userId.getString();
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();
    final formalFromLanguage =
        LanguageConverter.toFormalLanguageCode(languageCode: fromLanguage);
    final formalLearningLanguage =
        LanguageConverter.toFormalLanguageCode(languageCode: learningLanguage);

    final now = DateTime.now();
    for (final List<dynamic> skillsInternal in json['currentCourse']
        ['skills']) {
      final skills = <Skill>[];
      for (final Map<String, dynamic> skill in skillsInternal) {
        final skillId = skill['id'];
        final skillName = skill['name'];

        skills.add(
          Skill.from(
            skillId: skillId,
            name: skillName,
            shortName: skill['shortName'],
            urlName: skill['urlName'],
            accessible: skill['accessible'] ?? false,
            iconId: skill['iconId'],
            lessons: skill['lessons'],
            strength: skill['strength'] ?? 0,
            lastLessonPerfect: skill['lastLessonPerfect'],
            finishedLevels: skill['finishedLevels'],
            levels: skill['levels'],
            tipAndNoteId: await _fetchTipAndNoteId(
              skillId: skillId,
              skillName: skillName,
              content: skill['tipsAndNotes'] ?? '',
              userId: userId,
              fromLanguage: fromLanguage,
              learningLanguage: learningLanguage,
              formalFromLanguage: formalFromLanguage,
              formalLearningLanguage: formalLearningLanguage,
              now: now,
            ),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      await _skillService.insertAll(skills: skills);
    }
  }

  Future<int> _fetchTipAndNoteId({
    required String skillId,
    required String skillName,
    required String content,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
    required String formalFromLanguage,
    required String formalLearningLanguage,
    required DateTime now,
  }) async {
    if (content.isEmpty) {
      // No tip and note
      return -1;
    }

    final insertedTipAndNote = await _tipAndNoteService.replaceById(
      tipAndNote: TipAndNote.from(
        skillId: skillId,
        skillName: skillName,
        content: content,
        contentSummary: _buildContentSummary(content: content),
        userId: userId,
        fromLanguage: fromLanguage,
        learningLanguage: learningLanguage,
        formalFromLanguage: formalFromLanguage,
        formalLearningLanguage: formalLearningLanguage,
        bookmarked: false,
        deleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return insertedTipAndNote.id;
  }

  String _buildContentSummary({
    required String content,
  }) {
    if (content.length <= _maxLengthTipAndNoteContent) {
      return content;
    }

    // Remove all html tags and new lines
    final parsedContent = Bidi.stripHtmlIfNeeded(
      content,
    ).replaceAll('\n', ' ');

    return parsedContent.substring(0, _maxLengthTipAndNoteContent - 3) + '...';
  }
}
