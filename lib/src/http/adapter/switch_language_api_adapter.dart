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
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';

class SwitchLanguageApiAdapter extends ApiAdapter {
  @override
  Future<ApiResponse> doExecute({
    required BuildContext context,
    final params = const <String, String>{},
  }) async {
    try {
      final response = await Duolingo.instance.switchLanguage(
        fromLanguage: params['fromLanguage'],
        learningLanguage: params['learningLanguage'],
      );

      if (response.status.isOk) {
        await CommonSharedPreferencesKey.currentFromLanguage
            .setString(params['fromLanguage']);
        await CommonSharedPreferencesKey.currentLearningLanguage
            .setString(params['learningLanguage']);

        return ApiResponse.from(
          fromApi: FromApi.switchLanguage,
          errorType: ErrorType.none,
        );
      } else if (response.status.isClientError) {
        return ApiResponse.from(
          fromApi: FromApi.switchLanguage,
          errorType: ErrorType.client,
        );
      } else if (response.status.isServerError) {
        return ApiResponse.from(
          fromApi: FromApi.switchLanguage,
          errorType: ErrorType.server,
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.switchLanguage,
        errorType: ErrorType.unknown,
      );
    } catch (e) {
      return ApiResponse.from(
        fromApi: FromApi.switchLanguage,
        errorType: ErrorType.unknown,
      );
    }
  }
}
