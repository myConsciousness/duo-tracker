// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/model/skill_model.dart';
import 'package:duo_tracker/src/repository/model/supported_language_model.dart';
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/model/voice_configuration_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/service/course_service.dart';
import 'package:duo_tracker/src/repository/service/learned_word_service.dart';
import 'package:duo_tracker/src/repository/service/skill_serviced.dart';
import 'package:duo_tracker/src/repository/service/supported_language_service.dart';
import 'package:duo_tracker/src/repository/service/user_service.dart';
import 'package:duo_tracker/src/repository/service/voice_configuration_service.dart';
import 'package:duo_tracker/src/repository/service/word_hint_service.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

/// The enum that manages API adapter type.
enum ApiAdapterType {
  login,
  user,
  versionInfo,
  overview,
}

abstract class ApiAdapter {
  /// Returns API adapter linked to the [type] passed as an argument.
  factory ApiAdapter.of({
    required ApiAdapterType type,
  }) {
    switch (type) {
      case ApiAdapterType.login:
        return _LoginApiAdapter();
      case ApiAdapterType.user:
        return _UserApiAdapter();
      case ApiAdapterType.versionInfo:
        return _VersionInfoAdapter();
      case ApiAdapterType.overview:
        return _LearnedWordApiAdapter();
    }
  }

  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
  });
}

abstract class _ApiAdapter implements ApiAdapter {
  @override
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
    final AwesomeDialog? dialog,
  }) async {
    if (!await Network.isConnected()) {
      return await _checkResponse(
        context: context,
        response: ApiResponse.from(
          fromApi: FromApi.none,
          errorType: ErrorType.network,
          message:
              'Could not detect a valid network. Please check the network environment and the network settings of the device.',
        ),
      );
    }

    return await _checkResponse(
      context: context,
      response: await doExecute(
        context: context,
        params: params,
      ),
    );
  }

  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  });

  Future<bool> _checkResponse({
    required final BuildContext context,
    required ApiResponse response,
  }) async {
    switch (response.errorType) {
      case ErrorType.none:
        if (response.message.isNotEmpty) {
          InfoSnackbar.from(context: context).show(
            content: response.message,
          );
        }

        if (response.fromApi == FromApi.login) {
          // Update user information
          if (!await _UserApiAdapter().execute(context: context)) {
            return false;
          }

          // Update version information
          if (!await _VersionInfoAdapter().execute(context: context)) {
            return false;
          }
        }

        return true;
      case ErrorType.network:
        await OpenSettings.openNetworkOperatorSetting();
        return false;
      case ErrorType.noUserRegistered:
        await showAuthDialog(
          context: context,
          barrierDismissible: false,
        );

        return false;
      case ErrorType.authentication:
        showAwesomeDialog(
            context: context,
            title: 'Authentication failure',
            dialogType: DialogType.WARNING,
            content: response.message);

        return false;
      case ErrorType.client:
        showAwesomeDialog(
          context: context,
          title: 'Client error',
          dialogType: DialogType.WARNING,
          content: response.message.isEmpty
              ? 'An error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );

        return false;
      case ErrorType.server:
        showAwesomeDialog(
          context: context,
          title: 'Server error',
          dialogType: DialogType.WARNING,
          content: response.message.isEmpty
              ? 'A server error occurred while communicating with the Duolingo API. Please try again later.'
              : response.message,
        );

        return false;
      case ErrorType.unknown:
        showAwesomeDialog(
          context: context,
          title: 'Unknown error',
          dialogType: DialogType.WARNING,
          content: response.message.isEmpty
              ? 'An unknown error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );

        return false;
    }
  }
}

class _VersionInfoAdapter extends _ApiAdapter {
  /// The supported language service
  final _supportedLanguageService = SupportedLanguageService.getInstance();

  /// The voice configuratio service
  final _voiceConfigurationService = VoiceConfigurationService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required BuildContext context,
    params = const <String, String>{},
  }) async {
    final response = await Api.versionInfo.request.send();
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(response.body);

      await _refreshSupportedLanguage(
        json: jsonMap,
      );

      await _refreshVoiceConfiguration(
        json: jsonMap,
      );

      return ApiResponse.from(
        fromApi: FromApi.versionInfo,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.versionInfo,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.versionInfo,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.versionInfo,
      errorType: ErrorType.unknown,
    );
  }

  Future<void> _refreshSupportedLanguage({
    required Map<String, dynamic> json,
  }) async {
    _supportedLanguageService.deleteAll();

    json['supported_directions'].forEach(
      (fromLanguage, learningLanguages) {
        learningLanguages.forEach(
          (learningLanguage) {
            _supportedLanguageService.insert(
              SupportedLanguage.from(
                fromLanguage: fromLanguage,
                learningLanguage: learningLanguage,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refreshVoiceConfiguration({
    required Map<String, dynamic> json,
  }) async {
    _voiceConfigurationService.deleteAll();

    final ttsBaseUrlHttps = json['tts_base_url'];
    final ttsBaseUrlHttp = json['tts_base_url_http'];
    final ttsVoiceConfiguration = json['tts_voice_configuration'];

    final supportedLanguages =
        await _supportedLanguageService.findByFromLanguage(fromLanguage: 'en');
    final Map<String, dynamic> ttsVoiceConfigurations =
        jsonDecode(ttsVoiceConfiguration['voices']);

    for (final SupportedLanguage supportedLanguage in supportedLanguages) {
      final learningLanguage = supportedLanguage.learningLanguage;

      if (ttsVoiceConfigurations.containsKey(learningLanguage)) {
        _voiceConfigurationService.insert(
          VoiceConfiguration.from(
            language: learningLanguage,
            voiceType: ttsVoiceConfigurations[learningLanguage],
            ttsBaseUrlHttps: ttsBaseUrlHttps,
            ttsBaseUrlHttp: ttsBaseUrlHttp,
            path: 'tts',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        _voiceConfigurationService.insert(
          VoiceConfiguration.from(
            language: learningLanguage,
            voiceType: learningLanguage,
            ttsBaseUrlHttps: ttsBaseUrlHttps,
            ttsBaseUrlHttp: ttsBaseUrlHttp,
            path: 'tts',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }
}

class _LoginApiAdapter extends _ApiAdapter {
  /// The required parameter for password
  static const _paramPassword = 'password';

  /// The required parameter for username
  static const _paramUsername = 'username';

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    final username = params[_paramUsername];
    final password = params[_paramPassword];

    if (username.isEmpty || password.isEmpty) {
      /// Enter this block at first time
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.noUserRegistered,
      );
    }

    final response = await Api.login.request.send(
      params: {
        'login': username,
        'password': password,
      },
    );

    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      if (jsonMap.containsKey('failure')) {
        return ApiResponse.from(
            fromApi: FromApi.login,
            errorType: ErrorType.authentication,
            message: 'The username or password was wrong.');
      } else {
        await CommonSharedPreferencesKey.username
            .setString(params[_paramUsername]);
        await CommonSharedPreferencesKey.password
            .setString(Encryption.encode(value: params[_paramPassword]));
        await CommonSharedPreferencesKey.userId.setString(jsonMap['user_id']);

        return ApiResponse.from(
          fromApi: FromApi.login,
          errorType: ErrorType.none,
          message: 'Your account has been authenticated.',
        );
      }
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.login,
      errorType: ErrorType.unknown,
    );
  }
}

class _UserApiAdapter extends _ApiAdapter {
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
    final response = await Api.user.request.send(params: {'userId': userId});
    final httpStatus = _HttpStatus.from(code: response.statusCode);

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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
    _courseService.deleteAll();

    for (final Map<String, dynamic> course in json['courses']) {
      _courseService.insert(
        Course.from(
          courseId: course['id'],
          title: course['title'],
          learningLanguage: course['learningLanguage'],
          fromLanguage: course['fromLanguage'],
          xp: course['xp'],
          crowns: course['crowns'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _refreshSkill({
    required Map<String, dynamic> json,
  }) async {
    _skillService.deleteAll();

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
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }
}

class _LearnedWordApiAdapter extends _ApiAdapter {
  /// The learned word service
  final _learnedWordService = LearnedWordService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    final response = await Api.learnedWord.request.send();
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final jsonMap = jsonDecode(response.body);
      final String languageString = jsonMap['language_string'];
      final String learningLanguage = jsonMap['learning_language'];
      final String fromLanguage = jsonMap['from_language'];

      final userId = await CommonSharedPreferencesKey.userId.getString();

      int sortOrder = 0;
      for (final Map<String, dynamic> overview in jsonMap['vocab_overview']) {
        final String wordId = overview['id'];
        final String wordString = overview['word_string'];

        await _learnedWordService.replaceById(
          LearnedWord.from(
            wordId: overview['id'],
            userId: userId,
            languageString: languageString,
            learningLanguage: learningLanguage,
            fromLanguage: fromLanguage,
            lexemeId: overview['lexeme_id'] ?? '',
            relatedLexemes: overview['related_lexemes'],
            strengthBars: overview['strength_bars'] ?? -1,
            infinitive: overview['infinitive'] ?? '',
            wordString: wordString,
            normalizedString: overview['normalized_string'] ?? '',
            pos: overview['pos'] ?? '',
            lastPracticedMs: overview['last_practiced_ms'] ?? -1,
            skill: overview['skill'] ?? '',
            lastPracticed: overview['last_practiced'] ?? '',
            strength: overview['strength'] ?? 0.0,
            skillUrlTitle: overview['skill_url_title'] ?? '',
            gender: overview['gender'] ?? '',
            bookmarked: false,
            completed: false,
            deleted: false,
            sortOrder: sortOrder++,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // Update word hint based on word id
        _WordHintApiAdapter().execute(
          context: context,
          params: {
            'wordId': wordId,
            'userId': userId,
            'learningLanguage': learningLanguage,
            'fromLanguage': fromLanguage,
            'sentence': wordString,
          },
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.learnedWord,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.learnedWord,
      errorType: ErrorType.unknown,
    );
  }
}

class _WordHintApiAdapter extends _ApiAdapter {
  /// The required parameter for word id
  static const _paramWordId = 'wordId';

  /// The word hint service
  final _wordHintService = WordHintService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    if (!params.containsKey(_paramWordId)) {
      throw FlutterError('The parameter "$_paramWordId" is required.');
    }

    final response = await Api.wordHint.request.send(params: params);
    final httpStatus = _HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      final hintsMatrix = _createHintsMatrix(
        json: jsonDecode(response.body),
      );

      await _refreshWordHints(
        params: params,
        hintsMatrix: hintsMatrix,
      );

      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.wordHint,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.wordHint,
      errorType: ErrorType.unknown,
    );
  }

  Map<String, List<String>> _createHintsMatrix({
    required Map<String, dynamic> json,
  }) {
    final hintsMatrix = <String, List<String>>{};

    for (final Map<String, dynamic> token in json['tokens']) {
      if (token['hint_table'] == null) {
        continue;
      }

      for (final Map<String, dynamic> row in token['hint_table']['rows']) {
        for (final Map<String, dynamic> cell in row['cells']) {
          if (cell.isNotEmpty) {
            final int colspan = cell['colspan'] ?? -1;
            final String key = colspan > 0
                ? _fetchWordString(token: token).substring(0, colspan)
                : token['value'];

            if (hintsMatrix.containsKey(key)) {
              final List<String> hintsInternal = hintsMatrix[key]!;
              final String hint = cell['hint'];

              if (!hintsInternal.contains(hint)) {
                hintsInternal.add(hint);
              }
            } else {
              hintsMatrix[key] = [cell['hint']];
            }
          }
        }
      }
    }

    return hintsMatrix;
  }

  String _fetchWordString({
    required Map<String, dynamic> token,
  }) {
    final hintTable = token['hint_table'];

    if (!hintTable.containsKey('headers')) {
      return token['value'];
    }

    String wordString = '';

    for (final Map<String, dynamic> header in hintTable['headers']) {
      wordString += header['token'];
    }

    return wordString;
  }

  Future<void> _refreshWordHints({
    required Map<String, String> params,
    required Map<String, List<String>> hintsMatrix,
  }) async {
    final wordId = params[_paramWordId]!;
    final userId = await CommonSharedPreferencesKey.userId.getString();
    final learningLanguage = params['learningLanguage']!;
    final fromLanguage = params['fromLanguage']!;

    // Refresh word hint based on word id and user id
    await _wordHintService.deleteByWordIdAndUserId(
      wordId,
      userId,
    );

    hintsMatrix.forEach(
      (String value, List<String> hints) {
        for (var hint in hints) {
          _wordHintService.insert(
            WordHint.from(
              wordId: wordId,
              userId: userId,
              learningLanguage: learningLanguage,
              fromLanguage: fromLanguage,
              value: value,
              hint: hint,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
      },
    );
  }
}

class _HttpStatus {
  /// Returns the new instance of [_HttpStatus] based on [code] passed as an argument.
  _HttpStatus.from({
    required this.code,
  });

  /// The status code
  final int code;

  bool get isAccepted => code == 200;

  bool get isClientError => 400 <= code && code < 500;

  bool get isServerError => 500 <= code && code < 600;
}
