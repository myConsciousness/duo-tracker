// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:encrypt/encrypt.dart' as encryption;

class Encryption {
  /// The encryptor
  static final _encrypter = encryption.Encrypter(
    encryption.Salsa20(
      encryption.Key.fromLength(32),
    ),
  );

  /// The initialization vector
  static final _iv = encryption.IV.fromLength(8);

  static String encode({required String value}) =>
      _encrypter.encrypt(value, iv: _iv).base64;

  static String decode({required String value}) =>
      _encrypter.decrypt64(value, iv: _iv);
}
