// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/voice_configuration_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class VoiceConfigurationRepository
    extends Repository<VoiceConfiguration> {
  Future<VoiceConfiguration> findByLanguage({
    required String language,
  });
}