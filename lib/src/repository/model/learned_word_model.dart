// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/boolean_text.dart';

class LearnedWord {
  int id = -1;
  String wordId;
  int userId;
  String languageString;
  String language;
  String fromLanguage;
  String lexemeId;
  List<String> relatedLexemes;
  int strengthBars;
  String infinitive;
  String wordString;
  String englishWord;
  String normalizedString;
  String pos;
  int lastPracticedMs;
  String skill;
  String lastPracticed;
  String displayLastPracticed;
  double strength;
  String skillUrlTitle;
  String gender;
  bool bookmarked;
  bool deleted;
  int sortOrder;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [LearnedWord].
  LearnedWord.empty()
      : this.wordId = '',
        this.userId = -1,
        this.languageString = '',
        this.language = '',
        this.fromLanguage = '',
        this.lexemeId = '',
        this.relatedLexemes = const <String>[],
        this.strengthBars = -1,
        this.infinitive = '',
        this.wordString = '',
        this.englishWord = '',
        this.normalizedString = '',
        this.pos = '',
        this.lastPracticedMs = -1,
        this.skill = '',
        this.lastPracticed = '',
        this.displayLastPracticed = '',
        this.strength = -1,
        this.skillUrlTitle = '',
        this.gender = '',
        this.bookmarked = false,
        this.deleted = false,
        this.sortOrder = -1;

  /// Returns the new instance of [LearnedWord] based on the parameters.
  LearnedWord.from({
    this.id = -1,
    required this.wordId,
    required this.userId,
    required this.languageString,
    required this.language,
    required this.fromLanguage,
    required this.lexemeId,
    required this.relatedLexemes,
    required this.strengthBars,
    required this.infinitive,
    required this.wordString,
    required this.englishWord,
    required this.normalizedString,
    required this.pos,
    required this.lastPracticedMs,
    required this.skill,
    required this.lastPracticed,
    required this.displayLastPracticed,
    required this.strength,
    required this.skillUrlTitle,
    required this.gender,
    required this.bookmarked,
    required this.deleted,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [LearnedWord] based on the [map] passed as an argument.
  factory LearnedWord.fromMap(Map<String, dynamic> map) => LearnedWord.from(
        id: map[_ColumnName.id],
        wordId: map[_ColumnName.wordId],
        userId: map[_ColumnName.userId],
        languageString: map[_ColumnName.languageString],
        language: map[_ColumnName.language],
        fromLanguage: map[_ColumnName.fromLanguage],
        lexemeId: map[_ColumnName.lexemeId],
        relatedLexemes: (map[_ColumnName.relatedLexemes] as String).split(','),
        strengthBars: map[_ColumnName.strengthBars],
        infinitive: map[_ColumnName.infinitive],
        wordString: map[_ColumnName.wordString],
        englishWord: map[_ColumnName.englishWord],
        normalizedString: map[_ColumnName.normalizedString],
        pos: map[_ColumnName.pos],
        lastPracticedMs: map[_ColumnName.lastPracticedMs],
        skill: map[_ColumnName.skill],
        lastPracticed: map[_ColumnName.lastPracticed],
        displayLastPracticed: map[_ColumnName.displayLastPracticed],
        strength: map[_ColumnName.strength],
        skillUrlTitle: map[_ColumnName.skillUrlTitle],
        gender: map[_ColumnName.gender],
        bookmarked: map[_ColumnName.bookmarked] == BooleanText.TRUE,
        deleted: map[_ColumnName.deleted] == BooleanText.TRUE,
        sortOrder: map[_ColumnName.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] == null ? 0 : map[_ColumnName.createdAt],
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] == null ? 0 : map[_ColumnName.updatedAt],
        ),
      );

  /// Returns this [History] model as [Map].
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map[_ColumnName.id] = this.id;
    map[_ColumnName.wordId] = this.wordId;
    map[_ColumnName.userId] = this.userId;
    map[_ColumnName.languageString] = this.languageString;
    map[_ColumnName.fromLanguage] = this.fromLanguage;
    map[_ColumnName.lexemeId] = this.lexemeId;
    map[_ColumnName.relatedLexemes] = this.relatedLexemes.join(',');
    map[_ColumnName.strengthBars] = this.strengthBars;
    map[_ColumnName.infinitive] = this.infinitive;
    map[_ColumnName.wordString] = this.wordString;
    map[_ColumnName.englishWord] = this.englishWord;
    map[_ColumnName.normalizedString] = this.normalizedString;
    map[_ColumnName.pos] = this.pos;
    map[_ColumnName.lastPracticedMs] = this.lastPracticedMs;
    map[_ColumnName.skill] = this.skill;
    map[_ColumnName.lastPracticed] = this.lastPracticed;
    map[_ColumnName.displayLastPracticed] = this.displayLastPracticed;
    map[_ColumnName.strength] = this.strength;
    map[_ColumnName.skillUrlTitle] = this.skillUrlTitle;
    map[_ColumnName.gender] = this.gender;
    map[_ColumnName.bookmarked] =
        this.bookmarked ? BooleanText.TRUE : BooleanText.FALSE;
    map[_ColumnName.deleted] =
        this.deleted ? BooleanText.TRUE : BooleanText.FALSE;
    map[_ColumnName.sortOrder] = this.sortOrder;
    map[_ColumnName.createdAt] = this.createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = this.updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => this._empty;
}

/// The internal const class that manages the column name of [LearnedWord] repository.
class _ColumnName {
  static const id = 'ID';
  static const wordId = 'WORD_ID';
  static const userId = 'USER_ID';
  static const languageString = 'LANGUAGE_STRING';
  static const language = 'LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const lexemeId = 'LEXEME_ID';
  static const relatedLexemes = 'RELATED_REXEMES';
  static const strengthBars = 'STRENGTH_BARS';
  static const infinitive = 'INFINITIVE';
  static const wordString = 'WORD_STRING';
  static const englishWord = 'ENGLISH_WORD';
  static const normalizedString = 'NORMALIZED_STRING';
  static const pos = 'POS';
  static const lastPracticedMs = 'LAST_PRACTICED_MS';
  static const skill = 'SKILL';
  static const lastPracticed = 'LAST_PRACTICED';
  static const displayLastPracticed = 'DISPLAY_LAST_PRACTICED';
  static const strength = 'STRENGTH';
  static const skillUrlTitle = 'SKILL_URL_TITLE';
  static const gender = 'GENDER';
  static const bookmarked = 'BOOKMARKED';
  static const deleted = 'DELETED';
  static const sortOrder = 'SORT_ORDER';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
