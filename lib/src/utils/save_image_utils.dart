// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class SaveImageUtils {
  static Future<void> saveOnGallery(GlobalKey key) async {
    final File file = await saveOnWorkspace(key);
    await GallerySaver.saveImage(file.path);
    file.delete();
  }

  static Future<File> saveOnWorkspace(GlobalKey key) async {
    final Uint8List? pngBytes = await _createPngBytes(key);

    final Directory directory = await getApplicationDocumentsDirectory();
    File imgFile = File('${directory.path}/qr_code_created_by_mrqr.png');
    imgFile.writeAsBytesSync(pngBytes!.toList());

    return imgFile;
  }

  static Future<Uint8List?> _createPngBytes(GlobalKey key) async {
    final RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);
    final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
