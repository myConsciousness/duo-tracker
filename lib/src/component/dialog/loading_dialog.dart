// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

void showLoadingDialog<T>({
  required BuildContext context,
  required String title,
  required Future<dynamic> future,
}) {
  showDialog(
    context: context,
    builder: (context) => FutureProgressDialog(
      future,
      message: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          const Text(
            'Please wait a moment...',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    ),
  );
}
