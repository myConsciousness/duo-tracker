// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/component/common_app_bar_titles.dart';
import 'package:duovoc/src/component/dialog/auth_dialog.dart';
import 'package:duovoc/src/http/api_adapter.dart';
import 'package:duovoc/src/preference/common_shared_preferences_key.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/service/learned_word_service.dart';
import 'package:duovoc/src/security/encryption.dart';
import 'package:flutter/material.dart';

class OverviewView extends StatefulWidget {
  OverviewView({Key? key}) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final _learnedWordService = LearnedWordService.getInstance();

  late List<LearnedWord> _learndWords;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CommonAppBarTitles(
            title: 'Learned Words',
            subTitle: 'English → Japanese',
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: this._fetchLearnedWords(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final List<LearnedWord> learnedWords = snapshot.data;

              return ReorderableListView.builder(
                itemCount: learnedWords.length,
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    // removing the item at oldIndex will shorten the list by 1.
                    newIndex -= 1;
                  }

                  final learnedWord = this._learndWords.removeAt(oldIndex);

                  super.setState(() {
                    this._learndWords.insert(newIndex, learnedWord);
                  });
                },
                itemBuilder: (context, index) {
                  final learnedWord = learnedWords[index];
                  return Card(
                    elevation: 2.0,
                    key: Key(learnedWords[index].sortOrder.toString()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(learnedWord.lastPracticed),
                            Text('${learnedWord.strength * 100}'),
                          ],
                        ),
                        Divider(),
                        ListTile(
                          leading: const Icon(Icons.people),
                          title: Text(learnedWord.wordString),
                          subtitle: Text(learnedWord.wordString),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      );

  Future<List<LearnedWord>> _fetchLearnedWords({
    required BuildContext context,
  }) async {
    await Adapter.of(type: ApiAdapterType.login).execute(
      context: context,
      params: {
        'login': await CommonSharedPreferencesKey.username.getString(),
        'password': Encryption.decode(
          value: await CommonSharedPreferencesKey.password.getString(),
        ),
      },
    );

    await Adapter.of(type: ApiAdapterType.overview).execute(context: context);

    final learnedWords =
        await this._learnedWordService.findByNotBookmarkedAndNotDeleted();
    this._learndWords = learnedWords;

    return learnedWords;
  }
}
