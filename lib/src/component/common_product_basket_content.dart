// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonProductBasketContent extends StatelessWidget {
  const CommonProductBasketContent({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.body,
  }) : super(key: key);

  /// The title
  final String title;

  /// The subtitle
  final String subtitle;

  /// The body
  final Widget body;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProductBasketTitle(
            title: title,
            subtitle: subtitle,
          ),
          const SizedBox(
            height: 20,
          ),
          body,
        ],
      );

  Widget _buildProductBasketTitle({
    required String title,
    required String subtitle,
  }) =>
      ListTile(
        leading: const Icon(FontAwesomeIcons.shoppingBasket),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
        ),
      );
}
