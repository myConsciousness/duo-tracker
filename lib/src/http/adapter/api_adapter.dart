// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/dialog/auth_dialog.dart';
import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/component/dialog/network_error_dialog.dart';
import 'package:duo_tracker/src/component/snackbar/success_snack_bar.dart';
import 'package:duo_tracker/src/http/adapter/adapter.dart';
import 'package:duo_tracker/src/http/api_response.dart';
import 'package:duo_tracker/src/http/const/error_type.dart';
import 'package:duo_tracker/src/http/const/from_api.dart';
import 'package:duo_tracker/src/http/network.dart';

abstract class ApiAdapter implements Adapter {
  @override
  Future<bool> execute({
    required final BuildContext context,
    final params = const <String, String>{},
  }) async {
    if (!await Network.isConnected()) {
      return await _checkResponse(
        context: context,
        response: ApiResponse.from(
          fromApi: FromApi.none,
          errorType: ErrorType.network,
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
          SuccessSnackBar.from(context: context).show(
            content: response.message,
          );
        }

        return true;
      case ErrorType.network:
        await showNetworkErrorDialog(context: context);
        return false;
      case ErrorType.noUserRegistered:
        await showAuthDialog(
          context: context,
          enableNavigatorPop: false,
        );

        return false;
      case ErrorType.noHintData:
        await showErrorDialog(
          context: context,
          title: 'Word Hint Not Found',
          content:
              'The hint data for the word to be downloaded does not exist in Duolingo.',
        );

        return false;
      case ErrorType.authentication:
        await showInputErrorDialog(context: context, content: response.message);

        return false;
      case ErrorType.client:
        await showErrorDialog(
          context: context,
          title: 'Client Error',
          content: response.message.isEmpty
              ? 'An error occurred while communicating with the Duolingo API. Please try again.'
              : response.message,
        );

        return false;
      case ErrorType.server:
        await showErrorDialog(
          context: context,
          title: 'Server Error',
          content: response.message.isEmpty
              ? 'A server error occurred while communicating with the Duolingo API. Please try again later.'
              : response.message,
        );

        return false;
      case ErrorType.unknown:
        await showErrorDialog(
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
