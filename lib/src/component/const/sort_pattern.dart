// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The enum that represents sort pattern.
enum SortPattern {
  asc,
  desc,
}

extension SortPatternExt on SortPattern {
  int get code {
    switch (this) {
      case SortPattern.asc:
        return 0;
      case SortPattern.desc:
        return 1;
    }
  }

  String get patternName {
    switch (this) {
      case SortPattern.asc:
        return 'ASC';
      case SortPattern.desc:
        return 'DESC';
    }
  }

  static SortPattern toEnum({required final int code}) {
    for (final SortPattern sortPattern in SortPattern.values) {
      if (code == sortPattern.code) {
        return sortPattern;
      }
    }

    return SortPattern.asc;
  }
}
