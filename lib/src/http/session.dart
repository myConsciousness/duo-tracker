// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:http/http.dart' as http;

class Session {
  /// The internal constructor for singleton.
  Session._internal();

  /// Returns the singleton instance of [Session].
  factory Session.getInstance() => _singletonInstance;

  /// The singleton instance of [_Session].
  static final _singletonInstance = Session._internal();

  /// The headers for cookie
  final _headers = <String, String>{};

  /// Returns cookie headers
  Map<String, String> get headers => _headers;

  http.Response updateCookie({required final http.Response response}) {
    _headers['cookie'] = response.headers['set-cookie'] ?? '';
    return response;
  }
}