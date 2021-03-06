// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
