// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/http/adapter/adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/network.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

abstract class ApiAdapter implements Adapter {
  @override
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
    final AwesomeDialog? dialog,
  }) async {
    if (!await Network.isConnected()) {
      return await _checkResponse(
        context: context,
        response: ApiResponse.from(
          fromApi: FromApi.none,
          errorType: ErrorType.network,
          message:
              'Could not detect a valid network. Please check the network environment and the network settings of the device.',
        ),
      );
    }

    return await _checkResponse(
      context: context,
      response: await doExecute(
        context: context,
        params: params,
      ),
    );
  }

  Future<ApiResponse> doExecute({
    required final BuildContext context,
    final params = const <String, String>{},
  });

  Future<bool> _checkResponse({
    required final BuildContext context,
    required ApiResponse response,
  }) async {
    switch (response.errorType) {
      case ErrorType.none:
        if (response.message.isNotEmpty) {
          InfoSnackbar.from(context: context).show(
            content: response.message,
          );
        }

        return true;
      case ErrorType.network:
        await OpenSettings.openNetworkOperatorSetting();
        return false;
      case ErrorType.noUserRegistered:
        await showAuthDialog(
          context: context,
        );

        return false;
      case ErrorType.authentication:
        showInputErrorDialog(context: context, content: response.message);

        return false;
      case ErrorType.client:
        showErrorDialog(
          context: context,
          title: 'Client Error',
          content: response.message.isEmpty
              ? 'An error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );

        return false;
      case ErrorType.server:
        showErrorDialog(
          context: context,
          title: 'Server Error',
          content: response.message.isEmpty
              ? 'A server error occurred while communicating with the Duolingo API. Please try again later.'
              : response.message,
        );

        return false;
      case ErrorType.unknown:
        showErrorDialog(
          context: context,
          title: 'Unknown Error',
          content: response.message.isEmpty
              ? 'An unknown error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );

        return false;
    }
  }
}
