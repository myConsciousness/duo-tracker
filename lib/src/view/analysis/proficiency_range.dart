// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class ProficiencyRange {
  /// The range from
  final double from;

  /// The range to
  final double to;

  /// Returns the new instance of [ProficiencyRange] based on [from] and [to].
  ProficiencyRange.from({
    required this.from,
    required this.to,
  });
}
