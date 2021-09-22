// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/adapter/api_adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/http_status.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:flutter/material.dart';

class SwitchLanguageApiAdapter extends ApiAdapter {
  @override
  Future<ApiResponse> doExecute({
    required BuildContext context,
    final params = const <String, String>{},
  }) async {
    final response =
        await DuolingoApi.switchLanguage.request.send(params: params);
    final httpStatus = HttpStatus.from(code: response.statusCode);

    if (httpStatus.isAccepted) {
      await CommonSharedPreferencesKey.currentFromLanguage
          .setString(params['fromLanguage']);
      await CommonSharedPreferencesKey.currentLearningLanguage
          .setString(params['learningLanguage']);

      return ApiResponse.from(
        fromApi: FromApi.switchLanguage,
        errorType: ErrorType.none,
      );
    } else if (httpStatus.isClientError) {
      return ApiResponse.from(
        fromApi: FromApi.switchLanguage,
        errorType: ErrorType.client,
      );
    } else if (httpStatus.isServerError) {
      return ApiResponse.from(
        fromApi: FromApi.switchLanguage,
        errorType: ErrorType.server,
      );
    }

    return ApiResponse.from(
      fromApi: FromApi.switchLanguage,
      errorType: ErrorType.unknown,
    );
  }
}
