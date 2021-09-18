// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/api_adapter.dart';
import 'package:duo_tracker/src/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:flutter/material.dart';

class DuolingoApiUtils {
  static Future<bool> refreshVersionInfo({
    required BuildContext context,
  }) async =>
      await ApiAdapter.of(type: ApiAdapterType.versionInfo)
          .execute(context: context);

  static Future<bool> authenticateAccount({
    required BuildContext context,
  }) async {
    final username = await CommonSharedPreferencesKey.username.getString();
    final password = Encryption.decode(
        value: await CommonSharedPreferencesKey.password.getString());

    final loginApi = ApiAdapter.of(type: ApiAdapterType.login);

    return await loginApi.execute(
      context: context,
      params: {
        'username': username,
        'password': password,
      },
    );
  }

  static Future<bool> refreshUser({
    required BuildContext context,
  }) async =>
      await ApiAdapter.of(type: ApiAdapterType.user).execute(context: context);

  static Future<bool> synchronizeLearnedWords({
    required BuildContext context,
  }) async =>
      await ApiAdapter.of(type: ApiAdapterType.overview)
          .execute(context: context);

  static Future<bool> switchLearnLanguage({
    required BuildContext context,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
      await ApiAdapter.of(type: ApiAdapterType.switchLanguage).execute(
        context: context,
        params: {
          'fromLanguage': fromLanguage,
          'learningLanguage': learningLanguage,
        },
      );
}
