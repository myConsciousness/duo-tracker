// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/const/error_type.dart';
import 'package:duo_tracker/src/http/const/from_api.dart';

class ApiResponse {
  /// Returns the new instance of [ApiResponse] based on [fromApi], [errorType] and [message].
  ApiResponse.from({
    required this.fromApi,
    required this.errorType,
    this.message = '',
  });

  /// The error type
  final ErrorType errorType;

  /// The from api
  final FromApi fromApi;

  /// The message
  final String message;

  /// Checks if response has error. Returns [true] if reponse has error otherwise [false].
  bool get hasError => errorType != ErrorType.none;
}
