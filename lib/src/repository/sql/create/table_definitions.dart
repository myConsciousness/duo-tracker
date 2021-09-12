// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The class that manages table definitions.
class TableDefinitions {
  /// The user
  static const user = '''
        CREATE TABLE USER (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          USER_ID TEXT NOT NULL UNIQUE,
          USERNAME TEXT NOT NULL,
          NAME TEXT NOT NULL,
          BIO TEXT NOT NULL,
          EMAIL TEXT NOT NULL,
          LOCATION TEXT,
          PROFILE_COUNTRY TEXT,
          INVITE_URL TEXT NOT NULL,
          CURRENT_COURSE_ID TEXT NOT NULL,
          LEARNING_LANGUAGE TEXT NOT NULL,
          FROM_LANGUAGE TEXT NOT NULL,
          TIMEZONE TEXT NOT NULL,
          TIMEZONE_OFFSET TEXT NOT NULL,
          PICTURE_URL TEXT NOT NULL,
          PLUS_STATUS TEXT NOT NULL,
          LINGOTS INTEGER NOT NULL,
          TOTAL_XP INTEGER NOT NULL,
          XP_GOAL INTEGER NOT NULL,
          WEEKLY_XP INTEGER NOT NULL,
          MONTHLY_XP INTEGER NOT NULL,
          XP_GOAL_MET_TODAY INTEGER NOT NULL,
          STREAK INTEGER NOT NULL,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The course
  static const course = '''
        CREATE TABLE COURSE (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          USER_ID TEXT NOT NULL,
          COURSE_ID TEXT NOT NULL,
          TITLE TEXT NOT NULL,
          LEARNING_LANGUAGE TEXT NOT NULL,
          FROM_LANGUAGE TEXT NOT NULL,
          XP INTEGER NOT NULL,
          CROWNS INTEGER NOT NULL,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The skill
  static const skill = '''
        CREATE TABLE SKILL (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          USER_ID TEXT NOT NULL,
          SKILL_ID TEXT NOT NULL,
          NAME TEXT NOT NULL,
          SHORT_NAME NOT NULL,
          URL_NAME TEXT NOT NULL,
          ICON_ID INTEGER NOT NULL,
          LESSONS INTEGER NOT NULL,
          STRENGTH REAL NOT NULL,
          LAST_LESSON_PERFECT TEXT NOT NULL,
          FINISHED_LEVELS INTEGER NOT NULL,
          LEVELS INTEGER NOT NULL,
          TIPS_AND_NOTES TEXT,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The supported language
  static const supportedLanguage = '''
        CREATE TABLE SUPPORTED_LANGUAGE (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          FROM_LANGUAGE TEXT NOT NULL,
          LEARNING_LANGUAGE TEXT NOT NULL,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The voice configuration
  static const voiceConfiguration = '''
        CREATE TABLE VOICE_CONFIGURATION (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          LANGUAGE TEXT NOT NULL,
          VOICE_TYPE TEXT NOT NULL,
          TTS_BASE_URL_HTTPS TEXT NOT NULL,
          TTS_BASE_URL_HTTP TEXT NOT NULL,
          PATH TEXT NOT NULL,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The learned word
  static const learnedWord = '''
        CREATE TABLE LEARNED_WORD (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          WORD_ID TEXT NOT NULL,
          USER_ID TEXT NOT NULL,
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
          BOOKMARKED TEXT NOT NULL,
          COMPLETED TEXT NOT NULL,
          DELETED TEXT NOT NULL,
          SORT_ORDER INTEGER,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  static const wordHint = '''
        CREATE TABLE WORD_HINT (
          ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          WORD_ID TEXT NOT NULL,
          USER_ID TEXT NOT NULL,
          LEARNING_LANGUAGE TEXT NOT NULL,
          FROM_LANGUAGE TEXT NOT NULL,
          VALUE TEXT NOT NULL,
          HINT TEXT NOT NULL,
          SORT_ORDER INTEGER NOT NULL,
          CREATED_AT INTEGER NOT NULL,
          UPDATED_AT INTEGER NOT NULL
        )
        ''';

  /// The learned word related lexeme
  static const learnedWordRelatedLexeme = '''
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
