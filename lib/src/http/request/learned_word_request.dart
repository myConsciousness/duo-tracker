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
class LearnedWordRequest extends Request {
  /// The internal constructor for singleton.
  LearnedWordRequest._internal();

  /// Returns the singleton instance of [LearnedWordRequest].
  factory LearnedWordRequest.getInstance() => _singletonInstance;

  /// The API uri
  static final _apiUri = Uri.parse(DuolingoApi.learnedWord.url);

  /// The session
  static final _session = Session.getInstance();

  /// The singleton instance of [LearnedWordRequest].
  static final _singletonInstance = LearnedWordRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.get(
        _apiUri,
        headers: _session.headers,
      );
}
