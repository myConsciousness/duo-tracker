// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum DuolingoPageLauncher {
  /// The learn word
  learnWord,

  /// The select language
  selectLangauge,
}

extension DuolingoPageLauncherExt on DuolingoPageLauncher {
  String get url {
    switch (this) {
      case DuolingoPageLauncher.learnWord:
        return 'https://www.duolingo.com/skill';
      case DuolingoPageLauncher.selectLangauge:
        return 'https://www.duolingo.com/courses';
    }
  }
}
