// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// The enum that manages API.
enum Api {
  /// User meta
  user_meta,

  /// Login
  login,

  /// Overview
  overview,

  /// Overview Translation
  overviewTranslation,

  /// Switch language
  switchLanguage,

  /// Version Information
  versionInfo,
}

/// The extension enum that manages Duolingo API.
extension DuolingoApi on Api {
  /// Returns the url linked to Duolingo API.
  String get url {
    switch (this) {
      case Api.user_meta:
        return 'https://www.duolingo.com/2017-06-30/users?username=';
      case Api.login:
        return 'https://www.duolingo.com/login';
      case Api.overview:
        return 'https://www.duolingo.com/vocabulary/overview';
      case Api.overviewTranslation:
        return 'https://d2.duolingo.com/words/hints';
      case Api.switchLanguage:
        return 'https://www.duolingo.com/switch_language';
      case Api.versionInfo:
        return 'https://www.duolingo.com/api/1/version_info';
    }
  }

  /// Returns http request linked to Duolingo API.
  Request get request {
    switch (this) {
      case Api.user_meta:
        return _LoginRequest.getInstance();
      case Api.login:
        return _LoginRequest.getInstance();
      case Api.overview:
        return _OverviewRequest.getInstance();
      case Api.overviewTranslation:
        return _OverviewTranslationRequest.getInstance();
      case Api.switchLanguage:
        return _SwitchLanguageRequest.getInstance();
      case Api.versionInfo:
        return _LoginRequest.getInstance();
    }
  }
}

/// The class that represents http request.
abstract class Request {
  static final _session = _Session.getInstance();

  _Session get session => _session;

  Future<http.Response> send({Map<String, String> params});
}

class _Session {
  /// The singleton instance of [_Session].
  static final _singletonInstance = _Session._internal();

  /// The internal constructor for singleton.
  _Session._internal();

  /// Returns the singleton instance of [_Session].
  factory _Session.getInstance() => _singletonInstance;

  /// The headers for cookie
  final _headers = <String, String>{};

  /// Returns cookie headers
  Map<String, String> get headers => this._headers;

  http.Response updateCookie({required final http.Response response}) {
    this._headers['cookie'] = response.headers['set-cookie'] ?? '';
    return response;
  }
}

class _LoginRequest extends Request {
  static const _paramLogin = 'login';
  static const _paramPassword = 'password';

  /// The singleton instance of [_LoginRequest].
  static final _singletonInstance = _LoginRequest._internal();

  /// The API uri
  static final _apiUri = Uri.parse(Api.login.url);

  /// The internal constructor for singleton.
  _LoginRequest._internal();

  /// Returns the singleton instance of [_LoginRequest].
  factory _LoginRequest.getInstance() => _singletonInstance;

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async {
    if (!params.containsKey(_paramLogin))
      throw FlutterError('The parameter key "$_paramLogin" is required.');
    if (!params.containsKey(_paramPassword))
      throw FlutterError('The parameter key "$_paramPassword" is required.');

    return super.session.updateCookie(
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

class _OverviewRequest extends Request {
  /// The singleton instance of [_OverviewRequest].
  static final _singletonInstance = _OverviewRequest._internal();

  /// The API uri
  static final _apiUri = Uri.parse(Api.overview.url);

  /// The internal constructor for singleton.
  _OverviewRequest._internal();

  /// Returns the singleton instance of [_OverviewRequest].
  factory _OverviewRequest.getInstance() => _singletonInstance;

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.get(
        _apiUri,
        headers: super.session.headers,
      );
}

class _OverviewTranslationRequest extends Request {
  /// The singleton instance of [_OverviewTranslationRequest].
  static final _singletonInstance = _OverviewTranslationRequest._internal();

  /// The internal constructor for singleton.
  _OverviewTranslationRequest._internal();

  /// Returns the singleton instance of [_OverviewTranslationRequest].
  factory _OverviewTranslationRequest.getInstance() => _singletonInstance;

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async {
    if (!params.containsKey('language'))
      throw FlutterError('The parameter key "language" is required.');
    if (!params.containsKey('fromLanguage'))
      throw FlutterError('The parameter key "fromLanguage" is required.');

    return await http.get(
      Uri.parse(
          '${Api.overviewTranslation.url}/${params['language']}/${params['fromLanguage']}'),
      headers: super.session.headers,
    );
  }
}

class _SwitchLanguageRequest extends Request {
  /// The singleton instance of [_SwitchLanguageRequest].
  static final _singletonInstance = _SwitchLanguageRequest._internal();

  /// The API uri
  static final _apiUri = Uri.parse(Api.switchLanguage.url);

  /// The internal constructor for singleton.
  _SwitchLanguageRequest._internal();

  /// Returns the singleton instance of [_SwitchLanguageRequest].
  factory _SwitchLanguageRequest.getInstance() => _singletonInstance;

  @override
  Future<http.Response> send({
    final params = const <String, String>{},
  }) async =>
      await http.post(
        _apiUri,
        headers: super.session.headers,
      );
}
