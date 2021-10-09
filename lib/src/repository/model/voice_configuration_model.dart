// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/voice_configuration_column.dart';

class VoiceConfiguration {
  int id = -1;
  String language;
  String voiceType;
  String ttsBaseUrlHttps;
  String ttsBaseUrlHttp;
  String path;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [VoiceConfiguration].
  VoiceConfiguration.empty()
      : _empty = true,
        language = '',
        voiceType = '',
        ttsBaseUrlHttps = '',
        ttsBaseUrlHttp = '',
        path = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

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
        id: map[VoiceConfigurationColumn.id],
        language: map[VoiceConfigurationColumn.language],
        voiceType: map[VoiceConfigurationColumn.voiceType],
        ttsBaseUrlHttps: map[VoiceConfigurationColumn.ttsBaseUrlHttps],
        ttsBaseUrlHttp: map[VoiceConfigurationColumn.ttsBaseUrlHttp],
        path: map[VoiceConfigurationColumn.path],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[VoiceConfigurationColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[VoiceConfigurationColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [VoiceConfiguration] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[VoiceConfigurationColumn.language] = language;
    map[VoiceConfigurationColumn.voiceType] = voiceType;
    map[VoiceConfigurationColumn.ttsBaseUrlHttps] = ttsBaseUrlHttps;
    map[VoiceConfigurationColumn.ttsBaseUrlHttp] = ttsBaseUrlHttp;
    map[VoiceConfigurationColumn.path] = path;
    map[VoiceConfigurationColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[VoiceConfigurationColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
