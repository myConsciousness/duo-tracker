// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/folder_service.dart';
import 'package:flutter/material.dart';

/// The folder service
final _folderService = FolderService.getInstance();

late AwesomeDialog _dialog;

final _folderName = TextEditingController();
final _remarks = TextEditingController();

Future<T?> showEditFolderDialog<T>({
  required BuildContext context,
  required int folderId,
  required FolderType folderType,
}) async {
  final dynamic folder = await _folderService.findById(folderId);

  _folderName.text = folder.alias.isEmpty ? folder.name : folder.alias;
  _remarks.text = folder.remarks;

  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.QUESTION,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    _getDialogTitle(folderType: folderType),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    CommonTextField(
                      controller: _folderName,
                      label: 'Folder Name',
                      hintText: 'Folder name (required)',
                      maxLength: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonTextField(
                      controller: _remarks,
                      label: 'Remarks',
                      hintText: 'Remarks about folder',
                      maxLines: 5,
                      maxLength: 200,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Apply Changes',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    final trimmedFolderName = _folderName.text.trim();

                    if (trimmedFolderName.isEmpty) {
                      await showInputErrorDialog(
                          context: context,
                          content: 'The folder name is required.');
                      return;
                    }

                    final userId =
                        await CommonSharedPreferencesKey.userId.getString();
                    final fromLanguage = await CommonSharedPreferencesKey
                        .currentFromLanguage
                        .getString();
                    final learningLanguage = await CommonSharedPreferencesKey
                        .currentLearningLanguage
                        .getString();

                    if (folder.name != trimmedFolderName) {
                      if (await _isFolderDuplicated(
                        folderType: folderType,
                        folderName: trimmedFolderName,
                        userId: userId,
                        fromLanguage: fromLanguage,
                        learningLanguage: learningLanguage,
                      )) {
                        await showInputErrorDialog(
                            context: context,
                            content:
                                'The folder "$trimmedFolderName" already exists.');
                        return;
                      }
                    }

                    folder.alias = _folderName.text;
                    folder.remarks = _remarks.text;
                    folder.updatedAt = DateTime.now();

                    await _updateFolder(
                      folderType: folderType,
                      folder: folder,
                    );

                    _dialog.dismiss();
                  },
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Cancel',
                  color: Theme.of(context).colorScheme.error,
                  pressEvent: () {
                    _dialog.dismiss();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await _dialog.show();
}

String _getDialogTitle({
  required FolderType folderType,
}) {
  switch (folderType) {
    case FolderType.none:
      throw UnimplementedError();
    case FolderType.word:
      return 'Edit Word Folder';
    case FolderType.voice:
      return 'Edit Playlist Folder';
    case FolderType.tipsAndNotes:
      return 'Edit Tips Folder';
  }
}

Future<bool> _isFolderDuplicated({
  required FolderType folderType,
  required String folderName,
  required String userId,
  required String fromLanguage,
  required String learningLanguage,
}) async =>
    await _folderService
        .checkExistByFolderTypeAndNameAndUserIdAndFromLanguageAndLearningLanguage(
      folderType: folderType,
      name: folderName,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );

Future<void> _updateFolder({
  required FolderType folderType,
  required dynamic folder,
}) async =>
    await _folderService.update(folder);
