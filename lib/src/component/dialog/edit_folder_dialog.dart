// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_text_field.dart';
import 'package:duo_tracker/src/repository/model/folder_model.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:duo_tracker/src/view/folder/folder_type.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/folder_service.dart';
import 'package:flutter/material.dart';

/// The folder service
final _folderService = FolderService.getInstance();

/// The dialog
late AwesomeDialog _dialog;

/// The stored folder
Folder? _storedFolder;

/// The folder name
final _folderName = TextEditingController();

/// The remarks
final _remarks = TextEditingController();

Future<T?> showEditFolderDialog<T>({
  required BuildContext context,
  required FolderType folderType,
  int folderId = -1,
}) async {
  if (folderId < 0) {
    // When there is no stored folder and create new
    _storedFolder = null;
    _folderName.text = '';
    _remarks.text = '';
  } else {
    /// When there is a stored folder and edit
    _storedFolder = await _folderService.findById(folderId);
    _folderName.text = _storedFolder!.name;
    _remarks.text = _storedFolder!.remarks;
  }

  _dialog = _buildDialog(
    context: context,
    folderType: folderType,
  );

  await _dialog.show();
}

AwesomeDialog _buildDialog({
  required BuildContext context,
  required FolderType folderType,
}) =>
    AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.QUESTION,
      btnOkColor: Theme.of(context).colorScheme.secondary,
      body: _buildDialogBody(
        context: context,
        folderType: folderType,
      ),
    );

Widget _buildDialogBody({
  required BuildContext context,
  required FolderType folderType,
}) =>
    StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: _buildDialogListBody(
              context: context,
              folderType: folderType,
            ),
          ),
        ),
      ),
    );

Widget _buildDialogListBody({
  required BuildContext context,
  required FolderType folderType,
}) =>
    ListBody(
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
        _buildInputFieldSection(),
        const SizedBox(
          height: 30,
        ),
        AnimatedButton(
          isFixedHeight: false,
          text: _okButtonName,
          color: Theme.of(context).colorScheme.secondaryVariant,
          pressEvent: () async => await _onPressedOk(
            context: context,
            folderType: folderType,
          ),
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
    );

Widget _buildInputFieldSection() => Column(
      children: [
        _buildFolderNameSection(),
        const SizedBox(height: 10),
        _buildFolderRemarksSection(),
      ],
    );

Widget _buildFolderNameSection() => CommonTextField(
      controller: _folderName,
      label: 'Folder Name',
      hintText: 'Folder name (required)',
      maxLength: 50,
      onChanged: (text) {
        _folderName.text = text;
      },
    );
Widget _buildFolderRemarksSection() => CommonTextField(
      controller: _remarks,
      label: 'Remarks',
      hintText: 'Remarks about folder',
      maxLines: 5,
      maxLength: 200,
      onChanged: (text) {
        _remarks.text = text;
      },
    );

String _getDialogTitle({
  required FolderType folderType,
}) {
  switch (folderType) {
    case FolderType.none:
      throw UnimplementedError();
    case FolderType.word:
      return '$_dialogTitlePrefix Word Folder';
    case FolderType.voice:
      return '$_dialogTitlePrefix Playlist Folder';
  }
}

String get _dialogTitlePrefix => _storedFolder != null ? 'Edit' : 'Create New';

String get _okButtonName => _storedFolder != null ? 'Apply Changes' : 'Create';

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
}) async {
  _storedFolder!.name = _folderName.text;
  _storedFolder!.remarks = _remarks.text;
  _storedFolder!.updatedAt = DateTime.now();

  await _folderService.update(_storedFolder!);
}

Future<void> _createNewFolder({
  required FolderType folderType,
  required String folderName,
  required String userId,
  required String fromLanguage,
  required String learningLanguage,
}) async =>
    await _folderService.insert(
      Folder.from(
        parentFolderId: -1,
        folderType: folderType,
        name: folderName,
        remarks: _remarks.text,
        userId: userId,
        fromLanguage: fromLanguage,
        learningLanguage: learningLanguage,
        formalFromLanguage: LanguageConverter.toFormalLanguageCode(
          languageCode: fromLanguage,
        ),
        formalLearningLanguage: LanguageConverter.toFormalLanguageCode(
          languageCode: learningLanguage,
        ),
        deleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

Future<void> _onPressedOk({
  required BuildContext context,
  required FolderType folderType,
}) async {
  final trimmedFolderName = _folderName.text.trim();

  if (trimmedFolderName.isEmpty) {
    await showInputErrorDialog(
        context: context, content: 'The folder name is required.');
    return;
  }

  final userId = await CommonSharedPreferencesKey.userId.getString();
  final fromLanguage =
      await CommonSharedPreferencesKey.currentFromLanguage.getString();
  final learningLanguage =
      await CommonSharedPreferencesKey.currentLearningLanguage.getString();

  if (_storedFolder != null && _storedFolder!.name != trimmedFolderName) {
    if (await _isFolderDuplicated(
      folderType: folderType,
      folderName: trimmedFolderName,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    )) {
      await showInputErrorDialog(
          context: context,
          content: 'The folder "$trimmedFolderName" already exists.');
      return;
    }
  }

  if (_storedFolder != null) {
    await _updateFolder(
      folderType: folderType,
    );
  } else {
    await _createNewFolder(
      folderType: folderType,
      folderName: trimmedFolderName,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );
  }

  _dialog.dismiss();
}
