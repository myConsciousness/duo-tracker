// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

Future<T?> showAlertDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) =>
    Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      DialogRoute<T>(
        context: context,
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(content),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        settings: routeSettings,
        themes: InheritedTheme.capture(
          from: context,
          to: Navigator.of(
            context,
            rootNavigator: useRootNavigator,
          ).context,
        ),
      ),
    );
