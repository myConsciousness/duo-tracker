// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_item_model.dart';
import 'package:duo_tracker/src/repository/model/learned_word_folder_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_item_service.dart';
import 'package:duo_tracker/src/repository/service/learned_word_folder_service.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

late AwesomeDialog _dialog;
late List<bool> _checkMarkers;
late List<bool> _checkMarkersOriginal;
late List<int> _folderIds;

/// The learned word folder service
final _learnedWordFolderService = LearnedWordFolderService.getInstance();

/// The learned word folder item service
final _learnedWordFolderItemService =
    LearnedWordFolderItemService.getInstance();

Future<T?> showSelectFolderDialog<T>({
  required BuildContext context,
  required String wordId,
}) async {
  _checkMarkers = [];
  _checkMarkersOriginal = [];
  _folderIds = [];

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
                    'Select Folder',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 200,
                  child: FutureBuilder(
                    future: _fetchDataSource(
                      wordId: wordId,
                    ),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Loading();
                      }

                      final List<LearnedWordFolder> folders = snapshot.data;

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
                    final fromLanguage = await CommonSharedPreferencesKey
                        .currentFromLanguage
                        .getString();
                    final learningLanguage = await CommonSharedPreferencesKey
                        .currentLearningLanguage
                        .getString();

                    for (final indexNum in range(0, _checkMarkers.length)) {
                      final index = indexNum.toInt();

                      if (_checkMarkers[index] ==
                          _checkMarkersOriginal[index]) {
                        // Nothing changed
                        continue;
                      }

                      if (_checkMarkers[index]) {
                        await _addFolderItem(
                          folderId: _folderIds[index],
                          wordId: wordId,
                          userId: userId,
                          fromLanguage: fromLanguage,
                          learningLanguage: learningLanguage,
                        );
                      } else {
                        await _removeFolderItem(
                            folderId: _folderIds[index],
                            wordId: wordId,
                            userId: userId,
                            fromLanguage: fromLanguage,
                            learningLanguage: learningLanguage);
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
  required int folderId,
  required String wordId,
  required String userId,
  required String fromLanguage,
  required String learningLanguage,
}) async =>
    await _learnedWordFolderItemService.insert(
      LearnedWordFolderItem.from(
        folderId: folderId,
        wordId: wordId,
        alias: '',
        remarks: '',
        userId: userId,
        fromLanguage: fromLanguage,
        learningLanguage: learningLanguage,
        sortOrder: 0,
        deleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

Future<void> _removeFolderItem({
  required int folderId,
  required String wordId,
  required String userId,
  required String fromLanguage,
  required String learningLanguage,
}) async =>
    await _learnedWordFolderItemService
        .deleteByFolderIdAndWordIdAndUserIdAndFromLanguageAndLearningLanguage(
      folderId: folderId,
      wordId: wordId,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );

Future<void> _createCheckMarkers({
  required List<LearnedWordFolder> folders,
  required String wordId,
}) async {
  final userId = await CommonSharedPreferencesKey.userId.getString();
  final fromLanguage =
      await CommonSharedPreferencesKey.currentFromLanguage.getString();
  final learningLanguage =
      await CommonSharedPreferencesKey.currentLearningLanguage.getString();

  for (final folder in folders) {
    final checked = await _learnedWordFolderItemService
        .checkExistByFolderIdAndWordIdAndUserIdAndFromLanguageAndLearningLanguage(
      folderId: folder.id,
      wordId: wordId,
      userId: userId,
      fromLanguage: fromLanguage,
      learningLanguage: learningLanguage,
    );

    _checkMarkers.add(checked);
    _checkMarkersOriginal.add(checked);
    _folderIds.add(folder.id);
  }
}

Future<List<LearnedWordFolder>> _fetchDataSource({
  required String wordId,
}) async {
  final userId = await CommonSharedPreferencesKey.userId.getString();
  final fromLanguage =
      await CommonSharedPreferencesKey.currentFromLanguage.getString();
  final learningLanguage =
      await CommonSharedPreferencesKey.currentLearningLanguage.getString();

  final folders = await _learnedWordFolderService
      .findByUserIdAndFromLanguageAndLearningLanguage(
    userId: userId,
    fromLanguage: fromLanguage,
    learningLanguage: learningLanguage,
  );

  if (_checkMarkers.isEmpty) {
    await _createCheckMarkers(
      folders: folders,
      wordId: wordId,
    );
  }

  return folders;
}
