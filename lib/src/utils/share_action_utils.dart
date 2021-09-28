// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:duo_tracker/src/component/snackbar/info_snack_bar.dart';
import 'package:duo_tracker/src/utils/save_image_utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareActionUtils {
  static Future<void> onPressedSaveImageButton({
    required BuildContext context,
    required GlobalKey key,
  }) async {
    await SaveImageUtils.saveOnGallery(key);
    InfoSnackbar.from(context: context).show(content: 'Saved on Gallery.');
  }

  static Future<void> onPressedShareImageButton({
    required GlobalKey key,
  }) async {
    final File file = await SaveImageUtils.saveOnWorkspace(key);

    await Share.shareFiles(
      [file.path],
      subject: '',
      text: '''''',
    );

    file.delete();
  }
}
