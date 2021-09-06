// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The class that manages table definitions.
class TableDefinitions {
  /// The learned word
  static const String learnedWord = '''
        CREATE TABLE LEARNED_WORD (
          ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          WORD_ID TEXT NOT NULL UNIQUE,
          USER_ID String NOT NULL,
          LANGUAGE_STRING TEXT NOT NULL,
          LEARNING_LANGUAGE TEXT NOT NULL,
          FROM_LANGUAGE TEXT NOT NULL,
          LEXEME_ID TEXT,
          RELATED_REXEMES TEXT,
          STRENGTH_BARS INTEGER,
          INFINITIVE TEXT,
          WORD_STRING TEXT,
          NORMALIZED_STRING TEXT,
          POS TEXT,
          LAST_PRACTICED_MS INTEGER,
          SKILL TEXT,
          LAST_PRACTICED TEXT,
          STRENGTH REAL,
          SKILL_URL_TITLE TEXT,
          GENDER TEXT,
          BOOKMARKED INTEGER NOT NULL,
          DELETED INTEGER NOT NULL,
          SORT_ORDER INTEGER NOT NULL AUTOINCREMENT,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The learned word related lexeme
  static const String learnedWordRelatedLexeme = '''
        CREATE TABLE LEARNED_WORD_RELATED_LEXEME (
          ID INTEGER NOT NULL PRIMARY KEY,
          LEXEME_ID TEXT NOT NULL UNIQUE,
          WORD_ID TEXT NOT NULL UNIQUE,
          WORD TEXT NOT NULL,
          LESSON_NAME TEXT NOT NULL,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';
}
