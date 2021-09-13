// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
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
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              centerTitle: true,
              title: CommonAppBarTitles(
                title: 'Lesson Tips & Notes',
                subTitle: widget.lessonName,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            )
          ],
          body: Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  Center(
                    child: Html(
                      data: '''
<!DOCTYPE html>
<html>
  <head>
    <style>
    table, th, td {
      border: 1px solid black;
      border-collapse: collapse;
    }
    th, td, p {
      padding: 5px;
      text-align: left;
    }
    </style>
  </head>
  <body>
    ${widget.html}
  </body
</html>
                  ''',
                      style: {
                        'body': Style(
                          fontSize: const FontSize(15),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        'h1': Style(
                          fontSize: const FontSize(23),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        'h2': Style(
                          fontSize: const FontSize(21),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        'h3': Style(
                          fontSize: const FontSize(19),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        'h4': Style(
                          fontSize: const FontSize(17),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        'th': Style(
                          fontSize: const FontSize(13),
                          padding: const EdgeInsets.all(10),
                          border: Border.all(
                              color: Theme.of(context).primaryColorLight),
                        ),
                        'td': Style(
                          fontSize: const FontSize(13),
                          padding: const EdgeInsets.all(10),
                          border: Border.all(
                              color: Theme.of(context).primaryColorLight),
                        ),
                        'li': Style(
                          margin: const EdgeInsets.all(15),
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
