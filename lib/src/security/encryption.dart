/// Copyright 2021 Kato Shinya.
///
/// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
/// in compliance with the License. You may obtain a copy of the License at
///
///     http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software distributed under the License
/// is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
/// or implied. See the License for the specific language governing permissions and limitations under
/// the License.

import 'package:encrypt/encrypt.dart' as encryption;

class Encryption {
  /// The encryptor
  static final encryption.Encrypter encrypter =
      encryption.Encrypter(encryption.Salsa20(encryption.Key.fromLength(32)));

  /// The initialization vector
  static final encryption.IV iv = encryption.IV.fromLength(8);

  static String encode({required String value}) =>
      encrypter.encrypt(value, iv: iv).base64;

  static String decode({required String value}) =>
      encrypter.decrypt64(value, iv: iv);
}
