// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonNestedScrollView extends StatelessWidget {
  const CommonNestedScrollView({
    Key? key,
    required this.title,
    this.actions = const [],
    required this.body,
  }) : super(key: key);

  final List<Widget> actions;
  final Widget body;
  final Widget title;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              centerTitle: true,
              flexibleSpace: title,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              actions: actions,
            ),
          ],
          body: body,
        ),
      );
}
