// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum FromApi {
  ///The none
  none,

  /// User meta
  user_meta,

  /// Login
  login,

  /// Overview
  learnedWord,

  /// Overview Translation
  wordHint,

  /// Switch language
  switchLanguage,

  /// Version Information
  versionInfo,
}

/// The enum manages response error type.
enum ErrorType {
  none,
  network,
  noUserRegistered,
  authentication,
  client,
  server,
  unknown,
}

class ApiResponse {
  /// The from api
  final FromApi fromApi;

  /// The error type
  final ErrorType errorType;

  /// The message
  final String message;

  /// Returns the new instance of [ApiResponse] based on [api], [errorType] and [message].
  ApiResponse.from({
    required this.fromApi,
    required this.errorType,
    this.message = '',
  });

  /// Checks if response has error. Returns [true] if reponse has error otherwise [false].
  bool get hasError => this.errorType != ErrorType.none;
}
