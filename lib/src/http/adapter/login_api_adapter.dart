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
import 'package:duo_tracker/src/security/encryption.dart';

class LoginApiAdapter extends ApiAdapter {
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

    try {
      final response = await Duolingo.instance.authenticate(
        username: username,
        password: password,
      );

      if (response.status.isOk) {
        if (response.hasError) {
          return ApiResponse.from(
              fromApi: FromApi.login,
              errorType: ErrorType.authentication,
              message: 'The username or password was wrong.');
        }

        await CommonSharedPreferencesKey.username
            .setString(params[_paramUsername]);
        await CommonSharedPreferencesKey.password
            .setString(Encryption.encode(value: params[_paramPassword]));
        await CommonSharedPreferencesKey.userId.setString(response.userId);

        return ApiResponse.from(
          fromApi: FromApi.login,
          errorType: ErrorType.none,
          message: 'Your account has been authenticated!',
        );
      } else if (response.status.isClientError) {
        return ApiResponse.from(
          fromApi: FromApi.login,
          errorType: ErrorType.client,
        );
      } else if (response.status.isServerError) {
        return ApiResponse.from(
          fromApi: FromApi.login,
          errorType: ErrorType.server,
        );
      }

      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.unknown,
      );
    } catch (e) {
      return ApiResponse.from(
        fromApi: FromApi.login,
        errorType: ErrorType.unknown,
      );
    }
  }
}
