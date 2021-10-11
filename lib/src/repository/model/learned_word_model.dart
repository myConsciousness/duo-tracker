// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/learned_word_column.dart';
import 'package:duo_tracker/src/repository/model/tips_and_notes_model.dart';
import 'package:duo_tracker/src/repository/model/word_hint_model.dart';

class LearnedWord {
  int id = -1;
  String wordId;
  String userId;
  String languageString;
  String learningLanguage;
  String fromLanguage;
  String formalLearningLanguage;
  String formalFromLanguage;
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
  DateTime createdAt;
  DateTime updatedAt;

  /// The tts voice urls from voice configuration repository
  List<String> ttsVoiceUrls = <String>[];

  /// The word hints from word hint repository
  List<WordHint> wordHints = [];

  /// The tips and notes from skill repository
  TipsAndNotes? tipsAndNotes;

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
        formalLearningLanguage = '',
        formalFromLanguage = '',
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
        sortOrder = -1,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [LearnedWord] based on the parameters.
  LearnedWord.from({
    this.id = -1,
    required this.wordId,
    required this.userId,
    required this.languageString,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.formalLearningLanguage,
    required this.formalFromLanguage,
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
        id: map[LearnedWordColumn.id],
        wordId: map[LearnedWordColumn.wordId],
        userId: map[LearnedWordColumn.userId],
        languageString: map[LearnedWordColumn.languageString],
        learningLanguage: map[LearnedWordColumn.learningLanguage],
        fromLanguage: map[LearnedWordColumn.fromLanguage],
        formalLearningLanguage: map[LearnedWordColumn.formalLearningLanguage],
        formalFromLanguage: map[LearnedWordColumn.formalFromLanguage],
        strengthBars: map[LearnedWordColumn.strengthBars],
        infinitive: map[LearnedWordColumn.infinitive],
        wordString: map[LearnedWordColumn.wordString],
        normalizedString: map[LearnedWordColumn.normalizedString],
        pos: map[LearnedWordColumn.pos],
        lastPracticedMs: map[LearnedWordColumn.lastPracticedMs],
        skill: map[LearnedWordColumn.skill],
        lastPracticed: map[LearnedWordColumn.lastPracticed],
        strength: map[LearnedWordColumn.strength],
        skillUrlTitle: map[LearnedWordColumn.skillUrlTitle],
        gender: map[LearnedWordColumn.gender],
        bookmarked: map[LearnedWordColumn.bookmarked] == BooleanText.true_,
        completed: map[LearnedWordColumn.completed] == BooleanText.true_,
        deleted: map[LearnedWordColumn.deleted] == BooleanText.true_,
        sortOrder: map[LearnedWordColumn.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [LearnedWord] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[LearnedWordColumn.wordId] = wordId;
    map[LearnedWordColumn.userId] = userId;
    map[LearnedWordColumn.languageString] = languageString;
    map[LearnedWordColumn.learningLanguage] = learningLanguage;
    map[LearnedWordColumn.fromLanguage] = fromLanguage;
    map[LearnedWordColumn.formalLearningLanguage] = formalLearningLanguage;
    map[LearnedWordColumn.formalFromLanguage] = formalFromLanguage;
    map[LearnedWordColumn.strengthBars] = strengthBars;
    map[LearnedWordColumn.infinitive] = infinitive;
    map[LearnedWordColumn.wordString] = wordString;
    map[LearnedWordColumn.normalizedString] = normalizedString;
    map[LearnedWordColumn.pos] = pos;
    map[LearnedWordColumn.lastPracticedMs] = lastPracticedMs;
    map[LearnedWordColumn.skill] = skill;
    map[LearnedWordColumn.lastPracticed] = lastPracticed;
    map[LearnedWordColumn.strength] = strength;
    map[LearnedWordColumn.skillUrlTitle] = skillUrlTitle;
    map[LearnedWordColumn.gender] = gender;
    map[LearnedWordColumn.bookmarked] =
        bookmarked ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordColumn.completed] =
        completed ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordColumn.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordColumn.sortOrder] = sortOrder;
    map[LearnedWordColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[LearnedWordColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
