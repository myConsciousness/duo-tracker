// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';

class LearnedWord {
  int id = -1;
  String wordId;
  String userId;
  String languageString;
  String learningLanguage;
  String fromLanguage;
  String lexemeId;
  List<dynamic> relatedLexemes;
  int strengthBars;
  String infinitive;
  String wordString;
  String normalizedString;
  String pos;
  int lastPracticedMs;
  String skill;
  String lastPracticed;
  double strength;
  String skillUrlTitle;
  String gender;
  bool bookmarked;
  bool completed;
  bool deleted;
  int sortOrder;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The tts voice urls from voice configuration repository
  List<String> ttsVoiceUrls = <String>[];

  /// The word hints from word hint repository
  List<WordHint> wordHints = [];

  /// The tips and notes from skill repository
  String tipsAndNotes = '';

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [LearnedWord].
  LearnedWord.empty()
      : _empty = true,
        wordId = '',
        userId = '',
        languageString = '',
        learningLanguage = '',
        fromLanguage = '',
        lexemeId = '',
        relatedLexemes = const <String>[],
        strengthBars = -1,
        infinitive = '',
        wordString = '',
        normalizedString = '',
        pos = '',
        lastPracticedMs = -1,
        skill = '',
        lastPracticed = '',
        strength = -1,
        skillUrlTitle = '',
        gender = '',
        bookmarked = false,
        completed = false,
        deleted = false,
        sortOrder = -1;

  /// Returns the new instance of [LearnedWord] based on the parameters.
  LearnedWord.from({
    this.id = -1,
    required this.wordId,
    required this.userId,
    required this.languageString,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.lexemeId,
    required this.relatedLexemes,
    required this.strengthBars,
    required this.infinitive,
    required this.wordString,
    required this.normalizedString,
    required this.pos,
    required this.lastPracticedMs,
    required this.skill,
    required this.lastPracticed,
    required this.strength,
    required this.skillUrlTitle,
    required this.gender,
    required this.bookmarked,
    required this.completed,
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
        learningLanguage: map[_ColumnName.learningLanguage],
        fromLanguage: map[_ColumnName.fromLanguage],
        lexemeId: map[_ColumnName.lexemeId],
        relatedLexemes: (map[_ColumnName.relatedLexemes] as String).split(','),
        strengthBars: map[_ColumnName.strengthBars],
        infinitive: map[_ColumnName.infinitive],
        wordString: map[_ColumnName.wordString],
        normalizedString: map[_ColumnName.normalizedString],
        pos: map[_ColumnName.pos],
        lastPracticedMs: map[_ColumnName.lastPracticedMs],
        skill: map[_ColumnName.skill],
        lastPracticed: map[_ColumnName.lastPracticed],
        strength: map[_ColumnName.strength],
        skillUrlTitle: map[_ColumnName.skillUrlTitle],
        gender: map[_ColumnName.gender],
        bookmarked: map[_ColumnName.bookmarked] == BooleanText.true_,
        completed: map[_ColumnName.completed] == BooleanText.true_,
        deleted: map[_ColumnName.deleted] == BooleanText.true_,
        sortOrder: map[_ColumnName.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [LearnedWord] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.wordId] = wordId;
    map[_ColumnName.userId] = userId;
    map[_ColumnName.languageString] = languageString;
    map[_ColumnName.learningLanguage] = learningLanguage;
    map[_ColumnName.fromLanguage] = fromLanguage;
    map[_ColumnName.lexemeId] = lexemeId;
    map[_ColumnName.relatedLexemes] = relatedLexemes.join(',');
    map[_ColumnName.strengthBars] = strengthBars;
    map[_ColumnName.infinitive] = infinitive;
    map[_ColumnName.wordString] = wordString;
    map[_ColumnName.normalizedString] = normalizedString;
    map[_ColumnName.pos] = pos;
    map[_ColumnName.lastPracticedMs] = lastPracticedMs;
    map[_ColumnName.skill] = skill;
    map[_ColumnName.lastPracticed] = lastPracticed;
    map[_ColumnName.strength] = strength;
    map[_ColumnName.skillUrlTitle] = skillUrlTitle;
    map[_ColumnName.gender] = gender;
    map[_ColumnName.bookmarked] =
        bookmarked ? BooleanText.true_ : BooleanText.false_;
    map[_ColumnName.completed] =
        completed ? BooleanText.true_ : BooleanText.false_;
    map[_ColumnName.deleted] = deleted ? BooleanText.true_ : BooleanText.false_;
    map[_ColumnName.sortOrder] = sortOrder;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [LearnedWord] repository.
class _ColumnName {
  static const id = 'ID';
  static const wordId = 'WORD_ID';
  static const userId = 'USER_ID';
  static const languageString = 'LANGUAGE_STRING';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const lexemeId = 'LEXEME_ID';
  static const relatedLexemes = 'RELATED_REXEMES';
  static const strengthBars = 'STRENGTH_BARS';
  static const infinitive = 'INFINITIVE';
  static const wordString = 'WORD_STRING';
  static const normalizedString = 'NORMALIZED_STRING';
  static const pos = 'POS';
  static const lastPracticedMs = 'LAST_PRACTICED_MS';
  static const skill = 'SKILL';
  static const lastPracticed = 'LAST_PRACTICED';
  static const strength = 'STRENGTH';
  static const skillUrlTitle = 'SKILL_URL_TITLE';
  static const gender = 'GENDER';
  static const bookmarked = 'BOOKMARKED';
  static const completed = 'COMPLETED';
  static const deleted = 'DELETED';
  static const sortOrder = 'SORT_ORDER';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
