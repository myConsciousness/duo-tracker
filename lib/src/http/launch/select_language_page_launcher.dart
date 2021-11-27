// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:duo_tracker/src/http/duolingo_page_launcher.dart';
import 'package:duo_tracker/src/http/launch/page_launcher.dart';

class SelectLanguagePageLauncher extends PageLauncher {
  @override
  Future<bool> doExecute({
    required BuildContext context,
    params = const <String, String>{},
  }) async =>
      await launch(
        DuolingoPageLauncher.selectLangauge.url,
        headers: super.session.headers,
      );
}
