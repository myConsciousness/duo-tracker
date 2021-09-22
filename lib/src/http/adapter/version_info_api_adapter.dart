// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/http_status.dart';
import 'package:duo_tracker/src/repository/model/supported_language_model.dart';
import 'package:duo_tracker/src/repository/model/voice_configuration_model.dart';
import 'package:duo_tracker/src/repository/service/supported_language_service.dart';
import 'package:duo_tracker/src/repository/service/voice_configuration_service.dart';
import 'package:flutter/material.dart';

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
    final response = await DuolingoApi.versionInfo.request.send();
    final httpStatus = HttpStatus.from(code: response.statusCode);

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

    final now = DateTime.now();
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
            createdAt: now,
            updatedAt: now,
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
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }
  }
}
