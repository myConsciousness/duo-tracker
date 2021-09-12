// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class VoiceConfiguration {
  int id = -1;
  String language;
  String voiceType;
  String ttsBaseUrlHttps;
  String ttsBaseUrlHttp;
  String path;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [VoiceConfiguration].
  VoiceConfiguration.empty()
      : _empty = true,
        language = '',
        voiceType = '',
        ttsBaseUrlHttps = '',
        ttsBaseUrlHttp = '',
        path = '';

  /// Returns the new instance of [VoiceConfiguration] based on the parameters.
  VoiceConfiguration.from({
    this.id = -1,
    required this.language,
    required this.voiceType,
    required this.ttsBaseUrlHttps,
    required this.ttsBaseUrlHttp,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [VoiceConfiguration] based on the [map] passed as an argument.
  factory VoiceConfiguration.fromMap(Map<String, dynamic> map) =>
      VoiceConfiguration.from(
        id: map[_ColumnName.id],
        language: map[_ColumnName.language],
        voiceType: map[_ColumnName.voiceType],
        ttsBaseUrlHttps: map[_ColumnName.ttsBaseUrlHttps],
        ttsBaseUrlHttp: map[_ColumnName.ttsBaseUrlHttp],
        path: map[_ColumnName.path],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [VoiceConfiguration] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.language] = language;
    map[_ColumnName.voiceType] = voiceType;
    map[_ColumnName.ttsBaseUrlHttps] = ttsBaseUrlHttps;
    map[_ColumnName.ttsBaseUrlHttp] = ttsBaseUrlHttp;
    map[_ColumnName.path] = path;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [VoiceConfiguration] repository.
class _ColumnName {
  static const id = 'ID';
  static const language = 'LANGUAGE';
  static const voiceType = 'VOICE_TYPE';
  static const ttsBaseUrlHttps = 'TTS_BASE_URL_HTTPS';
  static const ttsBaseUrlHttp = 'TTS_BASE_URL_HTTP';
  static const path = 'PATH';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
