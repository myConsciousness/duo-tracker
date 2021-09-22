// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:flutter/material.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({Key? key}) : super(key: key);

  @override
  _UserAccountViewState createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  @override
  Widget build(BuildContext context) {
    return CommonNestesScrollView(
      title: const CommonAppBarTitles(
        title: 'User Account',
        subTitle: 'Achievements',
      ),
      body: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Text(
                  'Kato Shinya',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
              const SizedBox(
                height: 25,
              ),
              Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 22,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: <Widget>[
                          _buildCardText(
                            title: 'Posts',
                            subTitle: '5200',
                          ),
                          _buildCardText(
                            title: 'Followers',
                            subTitle: '28.5K',
                          ),
                          _buildCardText(
                            title: 'Follow',
                            subTitle: '1300',
                          ),
                        ],
                      ),
                      _divider,
                      Row(
                        children: <Widget>[
                          _buildCardText(
                            title: 'Posts',
                            subTitle: '5200',
                          ),
                          _buildCardText(
                            title: 'Followers',
                            subTitle: '28.5K',
                          ),
                          _buildCardText(
                            title: 'Follow',
                            subTitle: '1300',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildCardText({
    required String title,
    required String subTitle,
  }) =>
      Expanded(
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.pinkAccent,
              ),
            )
          ],
        ),
      );

  Divider get _divider => Divider(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      );
}
