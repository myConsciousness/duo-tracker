// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:duolingo4d/duolingo4d.dart';

// Project imports:
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/http/launch/launcher.dart';
import 'package:duo_tracker/src/http/network.dart';

abstract class PageLauncher extends Launcher {
  /// Returns the new instance of [PageLauncher] based on an argument.
  PageLauncher.from({
    required this.session,
  });

  /// The session
  final DuolingoSession session;

  @override
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    if (!await Network.isConnected()) {
      await showNetworkErrorDialog(context: context);
      return false;
    }

    return await doExecute(
      context: context,
      params: params,
    );
  }

  Future<bool> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  });
}
