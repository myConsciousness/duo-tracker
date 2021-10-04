// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_service.dart';
import 'package:flutter/material.dart';

/// The learned word folder service
final _learnedWordFolderService = LearnedWordFolderService.getInstance();

late AwesomeDialog _dialog;

final _folderName = TextEditingController();
final _remarks = TextEditingController();

Future<T?> showCreateNewFolderDialog<T>({
  required BuildContext context,
}) async {
  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.QUESTION,
    btnOkColor: Theme.of(context).colorScheme.secondary,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Container(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Center(
                  child: Text(
                    'Create New Folder',
                    style: TextStyle(
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
                  text: 'Create',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    if (_folderName.text.isEmpty) {
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

                    await _learnedWordFolderService.insert(
                      LearnedWordFolder.from(
                        parentFolderId: -1,
                        name: _folderName.text,
                        alias: '',
                        remarks: _remarks.text,
                        userId: userId,
                        fromLanguage: fromLanguage,
                        learningLanguage: learningLanguage,
                        sortOrder: 2,
                        deleted: false,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
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
                  height: 30,
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
