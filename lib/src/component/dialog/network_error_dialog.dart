// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/component/dialog/error_dialog.dart';
import 'package:flutter/material.dart';

void showNetworkErrorDialog<T>({
  required BuildContext context,
}) {
  showErrorDialog(
    context: context,
    title: 'Network Error',
    content:
        'Could not detect a valid network. Please check the network environment and the network settings of the device.',
  );
}
