// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';

class CommonAppBarTitles extends StatefulWidget {
  const CommonAppBarTitles({
    Key? key,
    required this.title,
    this.subTitle = '',
  }) : super(key: key);

  /// The subtitle
  final String subTitle;

  /// The title
  final String title;

  @override
  _CommonAppBarTitlesState createState() => _CommonAppBarTitlesState();
}

class _CommonAppBarTitlesState extends State<CommonAppBarTitles> {
  Widget _buildSubTitleText() {
    if (widget.subTitle.isEmpty) {
      return FutureBuilder(
        future: _buildSubTitle(),
        builder: (_, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }

          return _buildCommonSubTitleText(data: snapshot.data);
        },
      );
    }

    return _buildCommonSubTitleText(data: widget.subTitle);
  }

  Widget _buildCommonSubTitleText({
    required String data,
  }) =>
      Text(
        data,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      );

  Future<String> _buildSubTitle() async {
    final fromLanguage =
        await CommonSharedPreferencesKey.currentFromLanguage.getString();
    final learningLanguage =
        await CommonSharedPreferencesKey.currentLearningLanguage.getString();
    final fromLanguageName =
        LanguageConverter.toName(languageCode: fromLanguage);
    final learningLanguageName =
        LanguageConverter.toName(languageCode: learningLanguage);

    return '$fromLanguageName → $learningLanguageName';
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildSubTitleText(),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ],
      );
}
