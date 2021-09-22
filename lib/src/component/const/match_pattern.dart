// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum MatchPattern {
  /// Partial match
  partial,

  /// Exact Match
  exact,

  /// Prefix match
  prefix,

  /// Suffix match
  suffix,
}

extension MatchPatternExt on MatchPattern {
  int get code {
    switch (this) {
      case MatchPattern.partial:
        return 0;
      case MatchPattern.exact:
        return 1;
      case MatchPattern.prefix:
        return 2;
      case MatchPattern.suffix:
        return 3;
    }
  }

  static MatchPattern toEnum({required final int code}) {
    for (final MatchPattern matchPattern in MatchPattern.values) {
      if (code == matchPattern.code) {
        return matchPattern;
      }
    }

    return MatchPattern.partial;
  }
}
