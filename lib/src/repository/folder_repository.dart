// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/folder_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';
import 'package:duo_tracker/src/view/folder/folder_type.dart';

abstract class FolderRepository extends Repository<Folder> {
  Future<List<Folder>>
      findByFolderTypeAndUserIdAndFromLanguageAndLearningLanguage({
    required FolderType folderType,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<bool>
      checkExistByFolderTypeAndNameAndUserIdAndFromLanguageAndLearningLanguage({
    required FolderType folderType,
    required String name,
    required String userId,
    required String fromLanguage,
    required String learningLanguage,
  });

  Future<void> replaceSortOrdersByIds({
    required List<Folder> folders,
  });
}
