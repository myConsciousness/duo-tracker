// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum FromApi {
  ///The none
  none,

  /// Login
  login,

  /// User
  user,

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
  noHintData,
  authentication,
  client,
  server,
  unknown,
}

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
