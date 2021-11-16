// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:duo_tracker/src/component/common_dialog_cancel_button.dart';
import 'package:duo_tracker/src/component/common_dialog_submit_button.dart';
import 'package:duo_tracker/src/component/common_dialog_title.dart';
import 'package:duo_tracker/src/component/dialog/input_error_dialog.dart';
import 'package:duo_tracker/src/component/text_with_horizontal_divider.dart';
import 'package:duo_tracker/src/http/duolingo_page_launcher.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/supported_language_service.dart';
import 'package:duo_tracker/src/utils/language_converter.dart';
import 'package:flutter/material.dart';

late List<DropdownMenuItem> _selectableFromLanguageItems;
late List<DropdownMenuItem> _selectableLearningLanguageItems;
dynamic _selectedFromLanguage = '';
dynamic _selectedLearningLanguage = '';

AwesomeDialog? _dialog;
bool _switchingLanguage = false;

/// The supported language service
final _supportedLanguageService = SupportedLanguageService.getInstance();

Future<T?> showSwitchLanguageDialog<T>({
  required BuildContext context,
  Function(
    String selectedFromLanguage,
    String selectedLearningLanguage,
  )?
      onSubmitted,
}) async {
  _selectableFromLanguageItems = [];
  _selectableLearningLanguageItems = [];

  final currentFromLanguage =
      await CommonSharedPreferencesKey.currentFromLanguage.getString();
  final currentLearningLanguage =
      await CommonSharedPreferencesKey.currentLearningLanguage.getString();

  _selectedFromLanguage = currentFromLanguage;
  _selectedLearningLanguage = currentLearningLanguage;

  await _refreshAvailableFromLanguages();
  await _refreshAvailableLearningLanguages(fromLanguage: currentFromLanguage);

  _dialog = AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: DialogType.QUESTION,
    body: StatefulBuilder(
      builder: (BuildContext context, setState) => Padding(
        padding: const EdgeInsets.all(13),
        child: Center(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const CommonDialogTitle(title: 'Select Language'),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    _createDropdownBelow(
                      context: context,
                      title: 'I Speak ...',
                      value: _selectedFromLanguage,
                      items: _selectableFromLanguageItems,
                      hint: LanguageConverter.toNameWithFormal(
                          languageCode: _selectedFromLanguage),
                      onChanged: (selectedItem) async {
                        _selectedFromLanguage = selectedItem;
                        _selectedLearningLanguage =
                            await _refreshAvailableLearningLanguages(
                          fromLanguage: selectedItem,
                        );

                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _createDropdownBelow(
                      context: context,
                      title: 'I Learn ...',
                      value: _selectedLearningLanguage,
                      items: _selectableLearningLanguageItems,
                      hint: LanguageConverter.toNameWithFormal(
                          languageCode: currentLearningLanguage),
                      onChanged: (selectedItem) {
                        setState(() {
                          _selectedLearningLanguage = selectedItem;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                CommonDialogSubmitButton(
                  title: 'Submit',
                  pressEvent: () async {
                    if (_switchingLanguage) {
                      // Prevents multiple presses.
                      return;
                    }

                    if (_selectedFromLanguage == currentFromLanguage &&
                        _selectedLearningLanguage == currentLearningLanguage) {
                      await showInputErrorDialog(
                        context: context,
                        content:
                            'The selected settings have already been applied.',
                      );

                      return;
                    }

                    _switchingLanguage = true;

                    await _dialog!.dismiss();

                    if (onSubmitted != null) {
                      onSubmitted.call(
                        _selectedFromLanguage,
                        _selectedLearningLanguage,
                      );
                    }

                    _switchingLanguage = false;
                  },
                ),
                CommonDialogCancelButton(
                  onPressEvent: () async => await _dialog!.dismiss(),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TextWithHorizontalDivider(
                  value: 'OR',
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Text(
                    'Select on Duolingo!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onPressed: () async => await DuolingoPageLauncher
                      .selectLangauge.build
                      .execute(context: context),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await _dialog!.show();
}

Widget _createDropdownBelow({
  required BuildContext context,
  required String title,
  required dynamic value,
  required List<DropdownMenuItem<dynamic>> items,
  required String hint,
  required ValueChanged<dynamic> onChanged,
}) =>
    Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownBelow(
          icon: const Icon(Icons.arrow_drop_down),
          itemWidth: 200,
          itemTextstyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          boxTextstyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          boxDecoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          boxPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          hint: Text(hint),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );

List<DropdownMenuItem> _createDropdownItems({
  required List<String> languages,
}) =>
    languages
        .map((language) => DropdownMenuItem(
            value: language,
            child: Text(
              LanguageConverter.toNameWithFormal(languageCode: language),
            )))
        .toList();

Future<void> _refreshAvailableFromLanguages() async {
  final availableFromLanguages =
      await _supportedLanguageService.findDistinctFromLanguages();
  _selectableFromLanguageItems =
      _createDropdownItems(languages: availableFromLanguages);
}

Future<String> _refreshAvailableLearningLanguages({
  required String fromLanguage,
}) async {
  final availableLearningLanguages = await _supportedLanguageService
      .findDistinctLearningLanguagesByFormalFromLanguage(
    formalFromLanguage: LanguageConverter.toFormalLanguageCode(
      languageCode: fromLanguage,
    ),
  );

  _selectableLearningLanguageItems = _createDropdownItems(
    languages: availableLearningLanguages,
  );

  return availableLearningLanguages[0];
}
