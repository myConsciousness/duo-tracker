// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SuccessSnackBar {
  /// Returns the new instance of [SuccessSnackBar] based on the [context] passed as an argument.
  SuccessSnackBar.from({
    required this.context,
  });

  /// The build context
  final BuildContext context;

  void show({
    required String content,
  }) {
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: content,
        icon: const Icon(
          Icons.done,
          color: Color(0x15000000),
          size: 120,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }
}
