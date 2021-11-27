// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:new_version/new_version.dart';

/// The class that wraps the [VersionStatus].
///
/// [VersionStatus] does not have a public constructor,
/// so if you want an empty VersionStatus for some process　you cannot create an empty instance.
/// Therefore, this wrapper class is used to create a pseudo-empty instance of [VersionStatus].
class VersionStatusWrapper {
  VersionStatusWrapper.from({
    required this.status,
  });

  /// The version status
  final VersionStatus? status;
}
