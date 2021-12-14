// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:duo_tracker/src/http/duolingo_api.dart';
import 'package:duo_tracker/src/http/request/request.dart';
import 'package:duo_tracker/src/http/session.dart';

@Deprecated('The process has been delegated to Duolingo4D.')
class UserRequest extends Request {
  /// The internal constructor for singleton.
  UserRequest._internal();

  /// Returns the singleton instance of [UserRequest].
  factory UserRequest.getInstance() => _singletonInstance;

  /// The required parameter for user id
  static const _paramUserId = 'userId';

  /// The session
  static final _session = Session.getInstance();

  /// The singleton instance of [UserRequest].
  static final _singletonInstance = UserRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async {
    super.checkParameterKey(params: params, name: _paramUserId);

    return await http.get(
      Uri.parse('${DuolingoApi.user.url}/${params[_paramUserId]}'),
      headers: _session.headers,
    );
  }
}
