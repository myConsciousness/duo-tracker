// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/component/common_app_bar_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LessonTipsView extends StatefulWidget {
  const LessonTipsView({
    Key? key,
    required this.lessonName,
    required this.html,
  }) : super(key: key);

  final String html;
  final String lessonName;

  @override
  _LessonTipsViewState createState() => _LessonTipsViewState();
}

class _LessonTipsViewState extends State<LessonTipsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonAppBarTitles(
          title: 'Lesson Tips & Notes',
          subTitle: widget.lessonName,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Center(
                  child: Html(
                data: widget.html,
                style: {
                  // tables will have the below background color
                  'h3': Style(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  'th': Style(
                    padding: const EdgeInsets.all(10),
                    border:
                        Border.all(color: Theme.of(context).primaryColorLight),
                  ),
                  'td': Style(
                    fontSize: const FontSize(12),
                    padding: const EdgeInsets.all(10),
                    border:
                        Border.all(color: Theme.of(context).primaryColorLight),
                  ),
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
