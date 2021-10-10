// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/add_new_folder_button.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/dialog/create_new_folder_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/folder_item_model.dart';
import 'package:duo_tracker/src/repository/model/folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/folder_item_service.dart';
import 'package:duo_tracker/src/repository/service/folder_service.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

late AwesomeDialog _dialog;
late List<bool> _checkMarkers;
late List<bool> _checkMarkersOriginal;
late List<int> _folderIds;
late bool _refreshCheckMarkers;

/// The folder service
final _folderService = FolderService.getInstance();

/// The folder item service
final _folderItemService = FolderItemService.getInstance();

/// The selected folder type
late FolderType _selectedFolderType;

Future<T?> showSelectFolderDialog<T>({
  required BuildContext context,
  required String wordId,
}) async {
  _checkMarkers = [];
  _checkMarkersOriginal = [];
  _folderIds = [];
  _refreshCheckMarkers = true;

  _selectedFolderType = FolderType.word;

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
                const Center(
                  child: Text(
                    'Select Folder',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CommonTwoGridsRadioListTile(
                  dataSource: const {
                    'Word': FolderType.word,
                    'Playlist': FolderType.voice,
                  },
                  groupValue: _selectedFolderType,
                  onChanged: (value) {
                    setState(() {
                      _selectedFolderType = value;
                      _refreshCheckMarkers = true;
                    });
                  },
                ),
                SizedBox(
                  height: 200,
                  child: FutureBuilder(
                    future: _fetchDataSource(
                      folderType: _selectedFolderType,
                      wordId: wordId,
                    ),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Loading();
                      }

                      final List<Folder> folders = snapshot.data;

                      if (folders.isEmpty) {
                        return AddNewFolderButton(
                          onPressedCreate: () async {
                            await showCreateNewFolderDialog(
                              context: context,
                              folderType: _selectedFolderType,
                            );

                            setState(() {
                              _refreshCheckMarkers = true;
                            });
                          },
                        );
                      }

                      return ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (BuildContext context, int index) {
                          final folder = folders[index];
                          return CheckboxListTile(
                            title: Text(folder.name),
                            subtitle: Text(folder.remarks),
                            value: _checkMarkers[index],
                            onChanged: (value) {
                              setState(() {
                                _checkMarkers[index] = value!;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedButton(
                  isFixedHeight: false,
                  text: 'Add',
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  pressEvent: () async {
                    final userId =
                        await CommonSharedPreferencesKey.userId.getString();

                    for (final indexNum in range(0, _checkMarkers.length)) {
                      final index = indexNum.toInt();

                      if (_checkMarkers[index] ==
                          _checkMarkersOriginal[index]) {
                        // Nothing changed
                        continue;
                      }

                      if (_checkMarkers[index]) {
                        await _addFolderItem(
                          folderType: _selectedFolderType,
                          folderId: _folderIds[index],
                          wordId: wordId,
                          userId: userId,
                        );
                      } else {
                        await _removeFolderItem(
                          folderType: _selectedFolderType,
                          folderId: _folderIds[index],
                          wordId: wordId,
                          userId: userId,
                        );
                      }
                    }

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

Future<void> _addFolderItem({
  required FolderType folderType,
  required int folderId,
  required String wordId,
  required String userId,
}) async =>
    await _folderItemService.insert(
      FolderItem.from(
        folderId: folderId,
        wordId: wordId,
        sentenceGroupId: -1,
        alias: '',
        remarks: '',
        userId: userId,
        sortOrder: 0,
        deleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

Future<void> _removeFolderItem({
  required FolderType folderType,
  required int folderId,
  required String wordId,
  required String userId,
}) async =>
    await _folderItemService.deleteByFolderIdAndWordIdAndUserId(
      folderId: folderId,
      wordId: wordId,
      userId: userId,
    );

Future<void> _createCheckMarkers({
  required FolderType folderType,
  required List<dynamic> folders,
  required String wordId,
}) async {
  _checkMarkers = [];
  _checkMarkersOriginal = [];
  _folderIds = [];

  for (final folder in folders) {
    final checked = await _isFolderAlreadyChecked(
      folderType: folderType,
      folderId: folder.id,
      wordId: wordId,
    );

    _checkMarkers.add(checked);
    _checkMarkersOriginal.add(checked);
    _folderIds.add(folder.id);
  }
}

Future<bool> _isFolderAlreadyChecked({
  required FolderType folderType,
  required int folderId,
  required String wordId,
}) async {
  final userId = await CommonSharedPreferencesKey.userId.getString();

  return await _folderItemService.checkExistByFolderIdAndWordIdAndUserId(
    folderId: folderId,
    wordId: wordId,
    userId: userId,
  );
}

Future<List<dynamic>> _fetchDataSource({
  required FolderType folderType,
  required String wordId,
}) async {
  final List<dynamic> folders = await _fetchFolders(
    folderType: folderType,
  );

  if (_refreshCheckMarkers) {
    await _createCheckMarkers(
      folderType: folderType,
      folders: folders,
      wordId: wordId,
    );

    _refreshCheckMarkers = false;
  }

  return folders;
}

Future<List<dynamic>> _fetchFolders({
  required FolderType folderType,
}) async {
  final userId = await CommonSharedPreferencesKey.userId.getString();
  final fromLanguage =
      await CommonSharedPreferencesKey.currentFromLanguage.getString();
  final learningLanguage =
      await CommonSharedPreferencesKey.currentLearningLanguage.getString();

  return await _folderService
      .findByFolderTypeAndUserIdAndFromLanguageAndLearningLanguage(
    folderType: folderType,
    userId: userId,
    fromLanguage: fromLanguage,
    learningLanguage: learningLanguage,
  );
}
