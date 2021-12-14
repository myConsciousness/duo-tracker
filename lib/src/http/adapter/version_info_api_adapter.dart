// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:duolingo4d/duolingo4d.dart';

// Project imports:
import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/const/error_type.dart';
import 'package:duo_tracker/src/http/const/from_api.dart';
import 'package:duo_tracker/src/repository/model/supported_language_model.dart';
import 'package:duo_tracker/src/repository/model/voice_configuration_model.dart';
import 'package:duo_tracker/src/repository/service/supported_language_service.dart';
import 'package:duo_tracker/src/repository/service/voice_configuration_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';

class VersionInfoAdapter extends ApiAdapter {
  /// The supported language service
  final _supportedLanguageService = SupportedLanguageService.getInstance();

  /// The voice configuratio service
  final _voiceConfigurationService = VoiceConfigurationService.getInstance();

  @override
  Future<ApiResponse> doExecute({
    required BuildContext context,
    params = const <String, String>{},
  }) async {
    try {
      final response = await Duolingo.instance.versionInfo();

      if (response.status.isOk) {
        await _refreshSupportedLanguage(
          response: response,
        );

        await _refreshVoiceConfiguration(
          response: response,
        );

        return ApiResponse.from(
          fromApi: FromApi.versionInfo,
          errorType: ErrorType.none,
        );
      } else if (response.status.isClientError) {
        return ApiResponse.from(
          fromApi: FromApi.versionInfo,
          errorType: ErrorType.client,
        );
      } else if (response.status.isServerError) {
        return ApiResponse.from(
          fromApi: FromApi.versionInfo,
          errorType: ErrorType.server,
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.versionInfo,
        errorType: ErrorType.unknown,
      );
    } catch (e) {
      return ApiResponse.from(
        fromApi: FromApi.versionInfo,
        errorType: ErrorType.unknown,
      );
    }
  }

  Future<void> _refreshSupportedLanguage({
    required VersionInfoResponse response,
  }) async {
    _supportedLanguageService.deleteAll();

    final now = DateTime.now();
    for (final supportedDirection in response.supportedDirections) {
      for (final learningLanguage in supportedDirection.learningLanguages) {
        _supportedLanguageService.insert(
          SupportedLanguage.from(
            fromLanguage: supportedDirection.fromLanguage,
            learningLanguage: learningLanguage,
            formalFromLanguage: LanguageConverter.toFormalLanguageCode(
              languageCode: supportedDirection.fromLanguage,
            ),
            formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
              languageCode: learningLanguage,
            ),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }
  }

  Future<void> _refreshVoiceConfiguration({
    required VersionInfoResponse response,
  }) async {
    _voiceConfigurationService.deleteAll();

    // Find all supported languages from English
    final supportedLanguages =
        await _supportedLanguageService.findByFromLanguage(fromLanguage: 'en');

    final now = DateTime.now();
    for (final supportedLanguage in supportedLanguages) {
      final learningLanguage = supportedLanguage.learningLanguage;
      _voiceConfigurationService.insert(
        VoiceConfiguration.from(
          language: learningLanguage,
          formalLanguage: LanguageConverter.toFormalLanguageCode(
            languageCode: learningLanguage,
          ),
          voiceType: _findVoiceType(
            learningLanguage: learningLanguage,
            voiceDirections: response.ttsVoiceConfiguration.voiceDirections,
          ),
          ttsBaseUrlHttps: response.ttsBaseUrl,
          ttsBaseUrlHttp: response.ttsBaseUrl,
          path: 'tts',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  String _findVoiceType({
    required String learningLanguage,
    required List<VoiceDirection> voiceDirections,
  }) {
    for (final voiceDirection in voiceDirections) {
      if (learningLanguage == voiceDirection.language) {
        return voiceDirection.voice;
      }
    }

    return '';
  }
}
