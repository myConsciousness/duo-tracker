// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:duolingo4d/duolingo4d.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:duo_tracker/src/http/duolingo_page_launcher.dart';
import 'package:duo_tracker/src/http/launch/page_launcher.dart';

class LearnWordPageLauncher extends PageLauncher {
  LearnWordPageLauncher.from({
    required DuolingoSession session,
  }) : super.from(session: session);

  /// The required parameter for learning language
  static const _paramLearningLanguage = 'learningLanguage';

  /// The required parameter for skill url title
  static const _paramSkillUrlTitle = 'skillUrlTitle';

  @override
  Future<bool> doExecute({
    required BuildContext context,
    params = const <String, String>{},
  }) async {
    super.checkParameterKey(params: params, name: _paramLearningLanguage);
    super.checkParameterKey(params: params, name: _paramSkillUrlTitle);

    return await launch(
      '${DuolingoPageLauncher.learnWord.url}/${params[_paramLearningLanguage]}/${params[_paramSkillUrlTitle]}/1',
      headers: super.session.requestHeader.toMap(),
      forceSafariVC: true,
      forceWebView: true,
    );
  }
}
