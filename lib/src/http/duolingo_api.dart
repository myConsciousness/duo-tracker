// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum that manages API.
enum Api {
  /// User meta
  user_meta,

  /// Login
  login,

  /// Overview
  overview,

  /// Overview Translation
  overviewTranslation,

  /// Switch language
  switchLanguage,

  /// Version Information
  versionInfo,
}

/// The extension enum that manages Duolingo API.
extension DuolingoApi on Api {
  String get url {
    switch (this) {
      case Api.user_meta:
        return 'https://www.duolingo.com/2017-06-30/users?username=';
      case Api.login:
        return 'https://www.duolingo.com/login';
      case Api.overview:
        return 'https://www.duolingo.com/vocabulary/overview';
      case Api.overviewTranslation:
        return 'https://d2.duolingo.com/words/hints/%s/%s';
      case Api.switchLanguage:
        return 'https://www.duolingo.com/switch_language';
      case Api.versionInfo:
        return 'https://www.duolingo.com/api/1/version_info';
    }
  }
}
