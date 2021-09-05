// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum manages response error type.
enum ErrorType {
  none,
  network,
  username,
  password,
  client,
  server,
  unknown,
}

class ApiResponse {
  /// The error type
  final ErrorType errorType;

  /// Returns the new instance of [ApiResponse] based on arguments.
  ApiResponse.from({
    required this.errorType,
  });

  /// Checks if response has error. Returns [true] if reponse has error otherwise [false].
  bool get hasError => this.errorType != ErrorType.none;
}
