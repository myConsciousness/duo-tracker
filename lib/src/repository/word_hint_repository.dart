// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/word_hint_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class WordHintRepository extends Repository<WordHint> {
  Future<List<WordHint>> findByWordIdAndUserId(
    String wordId,
    String userId,
  );

  Future<void> deleteByWordIdAndUserId(
    String wordId,
    String userId,
  );
}
