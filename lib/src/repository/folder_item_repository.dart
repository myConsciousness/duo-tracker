// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/folder_item_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class FolderItemRepository extends Repository<FolderItem> {
  Future<List<FolderItem>>
      findByFolderIdAndUserIdAndFromLanguageAndLearningLanguage({
    required int folderId,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<int> countByFolderIdAndUserIdAndFromLanguageAndLearningLanguage({
    required int folderId,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<bool>
      checkExistByFolderIdAndWordIdAndUserIdAndFromLanguageAndLearningLanguage({
    required int folderId,
    required String wordId,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<void>
      deleteByFolderIdAndWordIdAndUserIdAndFromLanguageAndLearningLanguage({
    required int folderId,
    required String wordId,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<void> deleteByFolderId({
    required int folderId,
  });
}