// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/duolingo_api_adapter.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/security/encryption.dart';
import 'package:flutter/material.dart';

class DuolingoApiUtils {
  static Future<bool> refreshVersionInfo({
    required BuildContext context,
  }) async =>
      await DuolingoApiAdapter.versionInfo.build.execute(context: context);

  static Future<bool> authenticateAccount({
    required BuildContext context,
    String username = '',
    String password = '',
  }) async {
    final usernameInternal = username.isEmpty
        ? await CommonSharedPreferencesKey.username.getString()
        : username;
    final passwordInternal = password.isEmpty
        ? Encryption.decode(
            value: await CommonSharedPreferencesKey.password.getString())
        : password;

    return await DuolingoApiAdapter.login.build.execute(
      context: context,
      params: {
        'username': usernameInternal,
        'password': passwordInternal,
      },
    );
  }

  static Future<bool> refreshUser({
    required BuildContext context,
  }) async =>
      await DuolingoApiAdapter.user.build.execute(context: context);

  static Future<bool> synchronizeLearnedWords({
    required BuildContext context,
  }) async =>
      await DuolingoApiAdapter.overview.build.execute(context: context);

  static Future<bool> switchLearnLanguage({
    required BuildContext context,
    required String fromLanguage,
    required String learningLanguage,
  }) async =>
      await DuolingoApiAdapter.switchLanguage.build.execute(
        context: context,
        params: {
          'fromLanguage': fromLanguage,
          'learningLanguage': learningLanguage,
        },
      );

  static Future<bool> downloadWordHint({
    required BuildContext context,
    required String wordId,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
    required String wordString,
  }) async =>
      await DuolingoApiAdapter.hint.build.execute(
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
