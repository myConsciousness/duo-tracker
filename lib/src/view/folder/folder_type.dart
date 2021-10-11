// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum that manages folder type.
enum FolderType {
  /// The none
  none,

  /// The word
  word,

  /// The voice
  voice,
}

extension FolderTypeExt on FolderType {
  /// Returns the code.
  int get code {
    switch (this) {
      case FolderType.none:
        return -1;
      case FolderType.word:
        return 0;
      case FolderType.voice:
        return 1;
    }
  }

  static FolderType toEnum({
    required int code,
  }) {
    for (final folderType in FolderType.values) {
      if (folderType.code == code) {
        return folderType;
      }
    }

    return FolderType.none;
  }
}
