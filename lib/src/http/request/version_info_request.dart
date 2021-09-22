// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:http/http.dart' as http;
import 'package:duo_tracker/src/http/request/request.dart';

class VersionInfoRequest extends Request {
  /// The internal constructor for singleton.
  VersionInfoRequest._internal();

  /// Returns the singleton instance of [VersionInfoRequest].
  factory VersionInfoRequest.getInstance() => _singletonInstance;

  /// The API uri
  static final _apiUri = Uri.parse(DuolingoApi.versionInfo.url);

  /// The singleton instance of [VersionInfoRequest].
  static final _singletonInstance = VersionInfoRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.get(_apiUri);
}
