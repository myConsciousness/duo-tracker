// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/dialog/loading_dialog.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/http/launch/launcher.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:duo_tracker/src/http/session.dart';
import 'package:duo_tracker/src/http/utils/duolingo_api_utils.dart';

abstract class PageLauncher extends Launcher {
  /// The session
  final _session = Session.getInstance();

  /// Returns the session
  Session get session => _session;

  @override
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    if (!await Network.isConnected()) {
      await showNetworkErrorDialog(context: context);
      return false;
    }

    if (_session.headers.isEmpty) {
      await showLoadingDialog(
        context: context,
        title: 'Authenticating Account',
        future: DuolingoApiUtils.authenticateAccount(context: context),
      );
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
