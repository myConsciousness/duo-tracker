// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/launch/launcher.dart';
import 'package:duo_tracker/src/http/launch/learn_word_page_launcher.dart';
import 'package:duo_tracker/src/http/launch/select_language_page_launcher.dart';

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

  Launcher get build {
    switch (this) {
      case DuolingoPageLauncher.learnWord:
        return LearnWordPageLauncher();
      case DuolingoPageLauncher.selectLangauge:
        return SelectLanguagePageLauncher();
    }
  }
}
