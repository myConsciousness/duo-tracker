// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:duolingo4d/duolingo4d.dart' as duolingo;
import 'package:intl/intl.dart';

// Project imports:
import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/const/error_type.dart';
import 'package:duo_tracker/src/http/const/from_api.dart';
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
    try {
      final userId = await CommonSharedPreferencesKey.userId.getString();
      final response = await duolingo.Duolingo.instance.user(userId: userId);

      if (response.status.isOk) {
        await _updateUser(response: response);
        await _refreshCourse(response: response);
        await _refreshSkill(response: response);

        return ApiResponse.from(
          fromApi: FromApi.user,
          errorType: ErrorType.none,
        );
      } else if (response.status.isClientError) {
        return ApiResponse.from(
          fromApi: FromApi.user,
          errorType: ErrorType.client,
        );
      } else if (response.status.isServerError) {
        return ApiResponse.from(
          fromApi: FromApi.user,
          errorType: ErrorType.server,
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.unknown,
      );
    } catch (e) {
      return ApiResponse.from(
        fromApi: FromApi.user,
        errorType: ErrorType.unknown,
      );
    }
  }

  Future<void> _updateUser({
    required duolingo.UserResponse response,
  }) async {
    final learningLanguage = response.trackingProperty.learningLanguage;
    final fromLanguage = response.fromLanguage;

    final now = DateTime.now();
    await _userService.replaceByUserId(
      user: User.from(
        userId: response.id,
        username: response.username,
        name: response.name,
        bio: response.biography,
        email: response.email,
        location: '',
        profileCountry: response.profileCountry,
        inviteUrl: response.inviteUrl,
        currentCourseId: response.currentCourseId,
        learningLanguage: learningLanguage,
        fromLanguage: fromLanguage,
        formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
          languageCode: learningLanguage,
        ),
        formalFromLanguage: LanguageConverter.toFormalLanguageCode(
          languageCode: fromLanguage,
        ),
        timezone: response.timezone,
        timezoneOffset: response.timezoneOffset,
        pictureUrl: response.pictureUrl,
        plusStatus: response.plusStatus,
        lingots: response.lingots,
        gems: response.gems,
        totalXp: response.totalXp,
        xpGoal: response.xpGoal,
        weeklyXp: response.weeklyXp,
        monthlyXp: response.monthlyXp,
        xpGoalMetToday: response.xpGoalMetToday,
        streak: response.streak,
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
    required duolingo.UserResponse response,
  }) async {
    await _courseService.deleteAll();

    final courses = <Course>[];
    final now = DateTime.now();
    for (final course in response.courses) {
      courses.add(
        Course.from(
          courseId: course.id,
          title: course.title,
          formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
            languageCode: course.learningLanguage,
          ),
          formalFromLanguage: LanguageConverter.toFormalLanguageCode(
            languageCode: course.fromLanguage,
          ),
          xp: course.xp,
          crowns: course.crowns,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    await _courseService.insertAll(courses: courses);
  }

  Future<void> _refreshSkill({
    required duolingo.UserResponse response,
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
    for (final skill in response.currentCourse.skills) {
      final skills = <Skill>[];
      final skillId = skill.id;
      final skillName = skill.name;

      skills.add(
        Skill.from(
          skillId: skillId,
          name: skillName,
          shortName: skill.shortName,
          urlName: skill.urlName,
          accessible: skill.isAccessible,
          iconId: skill.iconId,
          lessons: skill.lessons,
          strength: skill.proficiency,
          lastLessonPerfect: skill.isPerfectOnLastLesson,
          finishedLevels: skill.finishedLevels,
          levels: skill.levels,
          tipAndNoteId: await _fetchTipAndNoteId(
            skillId: skillId,
            skillName: skillName,
            content: skill.tipsAndNotes,
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
