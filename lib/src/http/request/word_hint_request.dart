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
class WordHintRequest extends Request {
  /// The internal constructor for singleton.
  WordHintRequest._internal();

  /// Returns the singleton instance of [WordHintRequest].
  factory WordHintRequest.getInstance() => _singletonInstance;

  /// The required parameter for from language
  static const _paramFromLanguage = 'fromLanguage';

  /// The required parameter for learning language
  static const _paramLearningLanguage = 'learningLanguage';

  /// The required parameter for sentence
  static const _paramSentence = 'sentence';

  /// The session
  static final _session = Session.getInstance();

  /// The singleton instance of [WordHintRequest].
  static final _singletonInstance = WordHintRequest._internal();

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
            '${DuolingoApi.wordHint.url}/${params[_paramLearningLanguage]}/${params[_paramFromLanguage]}?sentence=${params[_paramSentence]}'),
      ),
      headers: _session.headers,
    );
  }
}
