// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/supported_language_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class SupportedLanguageRepository
    extends Repository<SupportedLanguage> {
  Future<List<SupportedLanguage>> findByFromLanguage({
    required String fromLanguage,
  });

  Future<List<String>> findDistinctFromLanguages();

  Future<List<String>> findDistinctLearningLanguagesByFormalFromLanguage({
    required String formalFromLanguage,
  });
}
