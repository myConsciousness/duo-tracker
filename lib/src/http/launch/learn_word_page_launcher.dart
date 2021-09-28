// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/duolingo_page_launcher.dart';
import 'package:duo_tracker/src/http/launch/page_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnWordPageLauncher extends PageLauncher {
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
      '${DuolingoPageLauncher.learnWord.url}/${params[_paramLearningLanguage]}/${params[_paramSkillUrlTitle]}',
      headers: super.session.headers,
      forceWebView: true,
    );
  }
}
