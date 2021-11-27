// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_html/flutter_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/repository/model/tip_and_note_model.dart';

class LessonTipsView extends StatefulWidget {
  const LessonTipsView({
    Key? key,
    required this.tipAndNote,
  }) : super(key: key);

  /// The tip and note
  final TipAndNote tipAndNote;

  @override
  _LessonTipsViewState createState() => _LessonTipsViewState();
}

class _LessonTipsViewState extends State<LessonTipsView> {
  /// The header banner ad
  late BannerAd _headerBannerAd;

  /// The bottom banner ad
  late BannerAd _bottomBannerAd;

  @override
  void initState() {
    super.initState();
    _headerBannerAd = BannerAdUtils.loadBannerAd();
    _bottomBannerAd = BannerAdUtils.loadBannerAd();
  }

  @override
  void dispose() {
    _headerBannerAd.dispose();
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              centerTitle: true,
              title: CommonAppBarTitles(
                title: 'Lesson Tip & Note',
                subTitle: widget.tipAndNote.skillName,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            )
          ],
          body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  FutureBuilder(
                    future: BannerAdUtils.canShow(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || !snapshot.data) {
                        return Container();
                      }

                      return BannerAdUtils.createBannerAdWidget(
                          _headerBannerAd);
                    },
                  ),
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
                            ${widget.tipAndNote.content}
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
                  FutureBuilder(
                    future: BannerAdUtils.canShow(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || !snapshot.data) {
                        return Container();
                      }

                      return BannerAdUtils.createBannerAdWidget(
                          _bottomBannerAd);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
