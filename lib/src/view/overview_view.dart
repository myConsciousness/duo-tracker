// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc_flutter/src/http/duolingo_api.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Container(
        child: FutureBuilder(
          future: Api.overview.request.send(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return ReorderableListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: [Text('')],
                      )
                    ],
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  // removing the item at oldIndex will shorten the list by 1.
                  newIndex -= 1;
                }

                final Model model = modelList.removeAt(oldIndex);

                super.setState(() {
                  modelList.insert(newIndex, model);
                });
              },
            );
          },
        ),
      ),
    );
  }
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
