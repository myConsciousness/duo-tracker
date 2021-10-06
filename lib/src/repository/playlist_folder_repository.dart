// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/playlist_folder_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class PlaylistFolderRepository extends Repository<PlaylistFolder> {
  Future<List<PlaylistFolder>> findByUserIdAndFromLanguageAndLearningLanguage({
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<bool>
      checkExistByFolderNameAndUserIdAndFromLanguageAndLearningLanguage({
    required String folderName,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });
}
