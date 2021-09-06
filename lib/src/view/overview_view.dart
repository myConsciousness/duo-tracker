// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/component/dialog/auth_dialog.dart';
import 'package:duovoc/src/component/common_app_bar_titles.dart';
import 'package:flutter/material.dart';

class OverviewView extends StatefulWidget {
  OverviewView({Key? key}) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  late List<Model> modelList;

  @override
  void initState() {
    super.initState();
    modelList = [];
    List<String> titleList = ["Title A", "Title B", "Title C"];
    List<String> subTitleList = ["SubTitle A", "SubTitle B", "SubTitle C"];
    for (int i = 0; i < 3; i++) {
      Model model = Model(
        title: titleList[i],
        subTitle: subTitleList[i],
        key: i.toString(),
      );
      modelList.add(model);
    }
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
          child: TextButton(
            child: Text('test'),
            onPressed: () {
              showAuthDialog(
                context: context,
              );
            },
          ),
        ),
      );
}

class Model {
  final String title;
  final String subTitle;
  final String key;

  Model({
    required this.title,
    required this.subTitle,
    required this.key,
  });
}
