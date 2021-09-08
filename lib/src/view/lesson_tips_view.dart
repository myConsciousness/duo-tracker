// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/component/common_app_bar_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LessonTipsView extends StatefulWidget {
  final String lessonName;
  final String html;

  LessonTipsView({
    Key? key,
    required this.lessonName,
    required this.html,
  }) : super(key: key);

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
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Center(
                  child: Html(
                data: '''
 <h3>Transitive and Intransitive Verb Pairs</h3>
    \n
    <p>
      The English language has certain sets of verbs that are related to each
      other but behave differently in a sentence.
      <strong>Transitive verbs</strong> like \"raise\" or \"lay\" always take a
      grammatical object. However, <strong>intransitive verbs</strong> like
      \"rise\" or \"lie\" never do. The same principle works in Japanese, with
      the examples below.
    </p>
    \n
    <h4>Transitive Verbs (take an object)</h4>
    \n
    <table>
      \n
      <thead>
        \n
        <tr>
          \n
          <th>Japanese</th>
          \n
          <th>English</th>
          \n
        </tr>
        \n
      </thead>
      \n
      <tbody>
        \n
        <tr>
          \n
          <td>上げる・あげる</td>
          \n
          <td>raise (something)</td>
          \n
        </tr>
        \n
        <tr>
          \n
          <td>下げる・さげる</td>
          \n
          <td>lower (something)</td>
          \n
        </tr>
        \n
      </tbody>
      \n
    </table>
    \n
    <h4>Intransitive Verbs (no object)</h4>
    \n
    <table>
      \n
      <thead>
        \n
        <tr>
          \n
          <th>Japanese</th>
          \n
          <th>English</th>
          \n
        </tr>
        \n
      </thead>
      \n
      <tbody>
        \n
        <tr>
          \n
          <td>上がる・あがる</td>
          \n
          <td>rise</td>
          \n
        </tr>
        \n
        <tr>
          \n
          <td>下がる・さがる</td>
          \n
          <td>fall</td>
          \n
        </tr>
        \n
      </tbody>
      \n
    </table>
    \n
    <p>
      So how do you know if and when a verb is <strong>transitive</strong> or
      <strong>intransitive</strong> in Japanese? Aside from noticing which verbs
      do and do not take grammatical objects, there are a few spelling patterns
      that can act as clues.
    </p>
    \n
    <ul>
      \n
      <li>
        <strong>Transitive</strong> verbs often end in え-sounds or す、like the
        verbs 始める (はじめる)、決める (きめる)、or 出す (だす)。
      </li>
      \n
      <li>
        Their <strong>intransitive</strong> pairings often end in あ-sounds,
        like the verbs 始まる (はじまる) or 決まる (きまる)。
      </li>
      \n
    </ul>
    \n
    <h3>Greetings at Work</h3>
    \n
    <p>
      Greetings and set phrases are an extremely important part of Japanese work
      culture. Below is a sampling of some of the most important points.
    </p>
    \n
    <table>
      \n
      <thead>
        \n
        <tr>
          \n
          <th>Phrase</th>
          \n
          <th>Occasion</th>
          \n
        </tr>
        \n
      </thead>
      \n
      <tbody>
        \n
        <tr>
          \n
          <td>おはようございます</td>
          \n
          <td>
            A standard morning greeting, occasionally shorted to
            ございます、ます、or simply a loud hiss.
          </td>
          \n
        </tr>
        \n
        <tr>
          \n
          <td>お疲れ様です</br>おつかれさまです</td>
          \n
          <td>
            A mid-day greeting to acknowledge that someone is doing such a good
            job that they look tired from doing so.
          </td>
          \n
        </tr>
        \n
        <tr>
          \n
          <td>失礼します</br>しつれいします</td>
          \n
          <td>A routine apology said when entering or leaving a room.</td>
          \n
        </tr>
        \n
        <tr>
          \n
          <td>お先に失礼します</br>おさきにしつれいします</td>
          \n
          <td>
            A routine apology said when leaving work before other people do so.
          </td>
          \n
        </tr>
        \n
        <tr>
          \n
          <td>お疲れ様でした</br>おつかれさまでした</td>
          \n
          <td>
            A routine response to \"お先に失礼します\", acknowledging that the
            coworker's hard work has been appreciated.
          </td>
          \n
        </tr>
        \n
      </tbody>
      \n
    </table>
''',
                style: {
                  // tables will have the below background color
                  'h3': Style(
                    color: Theme.of(context).accentColor,
                  ),
                  'th': Style(
                    padding: EdgeInsets.all(10),
                    border:
                        Border.all(color: Theme.of(context).primaryColorLight),
                  ),
                  'td': Style(
                    fontSize: FontSize(12),
                    padding: EdgeInsets.all(10),
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
