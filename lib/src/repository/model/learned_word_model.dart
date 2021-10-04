// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/boolean_text.dart';
import 'package:duo_tracker/src/repository/const/column/learned_word_column_name.dart';
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
  String lexemeId;
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
        formalLearningLanguage = '',
        formalFromLanguage = '',
        lexemeId = '',
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
    required this.lexemeId,
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
        id: map[LearnedWordColumnName.id],
        wordId: map[LearnedWordColumnName.wordId],
        userId: map[LearnedWordColumnName.userId],
        languageString: map[LearnedWordColumnName.languageString],
        learningLanguage: map[LearnedWordColumnName.learningLanguage],
        fromLanguage: map[LearnedWordColumnName.fromLanguage],
        formalLearningLanguage:
            map[LearnedWordColumnName.formalLearningLanguage],
        formalFromLanguage: map[LearnedWordColumnName.formalFromLanguage],
        lexemeId: map[LearnedWordColumnName.lexemeId],
        strengthBars: map[LearnedWordColumnName.strengthBars],
        infinitive: map[LearnedWordColumnName.infinitive],
        wordString: map[LearnedWordColumnName.wordString],
        normalizedString: map[LearnedWordColumnName.normalizedString],
        pos: map[LearnedWordColumnName.pos],
        lastPracticedMs: map[LearnedWordColumnName.lastPracticedMs],
        skill: map[LearnedWordColumnName.skill],
        lastPracticed: map[LearnedWordColumnName.lastPracticed],
        strength: map[LearnedWordColumnName.strength],
        skillUrlTitle: map[LearnedWordColumnName.skillUrlTitle],
        gender: map[LearnedWordColumnName.gender],
        bookmarked: map[LearnedWordColumnName.bookmarked] == BooleanText.true_,
        completed: map[LearnedWordColumnName.completed] == BooleanText.true_,
        deleted: map[LearnedWordColumnName.deleted] == BooleanText.true_,
        sortOrder: map[LearnedWordColumnName.sortOrder],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[LearnedWordColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [LearnedWord] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[LearnedWordColumnName.wordId] = wordId;
    map[LearnedWordColumnName.userId] = userId;
    map[LearnedWordColumnName.languageString] = languageString;
    map[LearnedWordColumnName.learningLanguage] = learningLanguage;
    map[LearnedWordColumnName.fromLanguage] = fromLanguage;
    map[LearnedWordColumnName.formalLearningLanguage] = formalLearningLanguage;
    map[LearnedWordColumnName.formalFromLanguage] = formalFromLanguage;
    map[LearnedWordColumnName.lexemeId] = lexemeId;
    map[LearnedWordColumnName.strengthBars] = strengthBars;
    map[LearnedWordColumnName.infinitive] = infinitive;
    map[LearnedWordColumnName.wordString] = wordString;
    map[LearnedWordColumnName.normalizedString] = normalizedString;
    map[LearnedWordColumnName.pos] = pos;
    map[LearnedWordColumnName.lastPracticedMs] = lastPracticedMs;
    map[LearnedWordColumnName.skill] = skill;
    map[LearnedWordColumnName.lastPracticed] = lastPracticed;
    map[LearnedWordColumnName.strength] = strength;
    map[LearnedWordColumnName.skillUrlTitle] = skillUrlTitle;
    map[LearnedWordColumnName.gender] = gender;
    map[LearnedWordColumnName.bookmarked] =
        bookmarked ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordColumnName.completed] =
        completed ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordColumnName.deleted] =
        deleted ? BooleanText.true_ : BooleanText.false_;
    map[LearnedWordColumnName.sortOrder] = sortOrder;
    map[LearnedWordColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[LearnedWordColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
