// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// The enum that manages API.
enum Api {
  /// Version Information
  versionInfo,

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
}

/// The extension enum that manages Duolingo API.
extension DuolingoApi on Api {
  /// Returns the url linked to Duolingo API.
  String get url {
    switch (this) {
      case Api.versionInfo:
        return 'https://www.duolingo.com/api/1/version_info';
      case Api.login:
        return 'https://www.duolingo.com/login';
      case Api.user:
        return 'https://www.duolingo.com/2017-06-30/users';
      case Api.learnedWord:
        return 'https://www.duolingo.com/vocabulary/overview';
      case Api.wordHint:
        return 'https://d2.duolingo.com/words/hints';
      case Api.switchLanguage:
        return 'https://www.duolingo.com/switch_language';
    }
  }

  /// Returns http request linked to Duolingo API.
  Request get request {
    switch (this) {
      case Api.versionInfo:
        return _VersionInfoRequest.getInstance();
      case Api.login:
        return _LoginRequest.getInstance();
      case Api.user:
        return _UserRequest.getInstance();
      case Api.learnedWord:
        return _LearnedWordRequest.getInstance();
      case Api.wordHint:
        return _WordHintRequest.getInstance();
      case Api.switchLanguage:
        return _SwitchLanguageRequest.getInstance();
    }
  }
}

/// The class that represents http request.
abstract class Request {
  Future<http.Response> send({Map<String, String> params});

  void checkParameterKey({
    required Map<String, String> params,
    required String name,
  }) {
    if (!params.containsKey(name)) {
      throw FlutterError('The parameter key "$name" is required.');
    }
  }
}

class _Session {
  /// The internal constructor for singleton.
  _Session._internal();

  /// Returns the singleton instance of [_Session].
  factory _Session.getInstance() => _singletonInstance;

  /// The singleton instance of [_Session].
  static final _singletonInstance = _Session._internal();

  /// The headers for cookie
  final _headers = <String, String>{};

  /// Returns cookie headers
  Map<String, String> get headers => _headers;

  http.Response updateCookie({required final http.Response response}) {
    _headers['cookie'] = response.headers['set-cookie'] ?? '';
    return response;
  }
}

class _VersionInfoRequest extends Request {
  /// The internal constructor for singleton.
  _VersionInfoRequest._internal();

  /// Returns the singleton instance of [_VersionInfoRequest].
  factory _VersionInfoRequest.getInstance() => _singletonInstance;

  /// The API uri
  static final _apiUri = Uri.parse(Api.versionInfo.url);

  /// The singleton instance of [_VersionInfoRequest].
  static final _singletonInstance = _VersionInfoRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.get(_apiUri);
}

class _LoginRequest extends Request {
  /// The internal constructor for singleton.
  _LoginRequest._internal();

  /// Returns the singleton instance of [_LoginRequest].
  factory _LoginRequest.getInstance() => _singletonInstance;

  /// The API uri
  static final _apiUri = Uri.parse(Api.login.url);

  /// The required parameter for username
  static const _paramLogin = 'login';

  /// The required parameter for password
  static const _paramPassword = 'password';

  /// The session
  static final _session = _Session.getInstance();

  /// The singleton instance of [_LoginRequest].
  static final _singletonInstance = _LoginRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async {
    super.checkParameterKey(params: params, name: _paramLogin);
    super.checkParameterKey(params: params, name: _paramPassword);

    return _session.updateCookie(
      response: await http.post(
        _apiUri,
        body: {
          _paramLogin: '${params[_paramLogin]}',
          _paramPassword: '${params[_paramPassword]}',
        },
      ),
    );
  }
}

class _UserRequest extends Request {
  /// The internal constructor for singleton.
  _UserRequest._internal();

  /// Returns the singleton instance of [_UserRequest].
  factory _UserRequest.getInstance() => _singletonInstance;

  /// The required parameter for user id
  static const _paramUserId = 'userId';

  /// The session
  static final _session = _Session.getInstance();

  /// The singleton instance of [_UserRequest].
  static final _singletonInstance = _UserRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async {
    super.checkParameterKey(params: params, name: _paramUserId);

    return await http.get(
      Uri.parse('${Api.user.url}/${params[_paramUserId]}'),
      headers: _session.headers,
    );
  }
}

class _LearnedWordRequest extends Request {
  /// The internal constructor for singleton.
  _LearnedWordRequest._internal();

  /// Returns the singleton instance of [_LearnedWordRequest].
  factory _LearnedWordRequest.getInstance() => _singletonInstance;

  /// The API uri
  static final _apiUri = Uri.parse(Api.learnedWord.url);

  /// The session
  static final _session = _Session.getInstance();

  /// The singleton instance of [_LearnedWordRequest].
  static final _singletonInstance = _LearnedWordRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.get(
        _apiUri,
        headers: _session.headers,
      );
}

class _WordHintRequest extends Request {
  /// The internal constructor for singleton.
  _WordHintRequest._internal();

  /// Returns the singleton instance of [_WordHintRequest].
  factory _WordHintRequest.getInstance() => _singletonInstance;

  /// The required parameter for from language
  static const _paramFromLanguage = 'fromLanguage';

  /// The required parameter for learning language
  static const _paramLearningLanguage = 'learningLanguage';

  /// The required parameter for sentence
  static const _paramSentence = 'sentence';

  /// The session
  static final _session = _Session.getInstance();

  /// The singleton instance of [_WordHintRequest].
  static final _singletonInstance = _WordHintRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async {
    super.checkParameterKey(params: params, name: _paramLearningLanguage);
    super.checkParameterKey(params: params, name: _paramFromLanguage);
    super.checkParameterKey(params: params, name: _paramSentence);

    return await http.get(
      Uri.parse(
        Uri.encodeFull(
            '${Api.wordHint.url}/${params[_paramLearningLanguage]}/${params[_paramFromLanguage]}?sentence=${params[_paramSentence]}'),
      ),
      headers: _session.headers,
    );
  }
}

class _SwitchLanguageRequest extends Request {
  /// The internal constructor for singleton.
  _SwitchLanguageRequest._internal();

  /// Returns the singleton instance of [_SwitchLanguageRequest].
  factory _SwitchLanguageRequest.getInstance() => _singletonInstance;

  /// The API uri
  static final _apiUri = Uri.parse(Api.switchLanguage.url);

  /// The session
  static final _session = _Session.getInstance();

  /// The singleton instance of [_SwitchLanguageRequest].
  static final _singletonInstance = _SwitchLanguageRequest._internal();

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.post(
        _apiUri,
        headers: _session.headers,
      );
}
