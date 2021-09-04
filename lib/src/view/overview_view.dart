// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: Container(
          child: ReorderableListView(
            padding: EdgeInsets.all(10.0),
            header: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "This is header",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                // removing the item at oldIndex will shorten the list by 1.
                newIndex -= 1;
              }
              final Model model = modelList.removeAt(oldIndex);

              setState(() {
                modelList.insert(newIndex, model);
              });
            },
            children: modelList.map(
              (Model model) {
                return Card(
                  elevation: 2.0,
                  key: Key(model.key),
                  child: ListTile(
                    leading: const Icon(Icons.people),
                    title: Text(model.title),
                    subtitle: Text(model.subTitle),
                  ),
                );
              },
            ).toList(),
          ),
        ));
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
