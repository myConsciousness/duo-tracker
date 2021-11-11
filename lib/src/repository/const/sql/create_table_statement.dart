// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum CreateTableStatement {
  /// The user table
  user,

  /// The course table
  course,

  /// The skill table
  skill,

  /// The supported language table
  supportedLanguage,

  /// The voice configuration table
  voiceConfiguration,

  /// The learned word table
  learnedWord,

  /// The word hint table
  wordHint,

  /// The purchase history table
  purchaseHistory,

  /// The folder table
  folder,

  /// The folder item table
  folderItem,

  /// The learbed word sentence table
  learnedWordSentence,

  /// The tip and note table
  tipAndNote
}

extension CreateTableStatementExt on CreateTableStatement {
  String get path {
    switch (this) {
      case CreateTableStatement.user:
        return 'assets/sql/ddl/create/create_table_user.sql';
      case CreateTableStatement.course:
        return 'assets/sql/ddl/create/create_table_course.sql';
      case CreateTableStatement.skill:
        return 'assets/sql/ddl/create/create_table_skill.sql';
      case CreateTableStatement.supportedLanguage:
        return 'assets/sql/ddl/create/create_table_supported_language.sql';
      case CreateTableStatement.voiceConfiguration:
        return 'assets/sql/ddl/create/create_table_voice_configuration.sql';
      case CreateTableStatement.learnedWord:
        return 'assets/sql/ddl/create/create_table_learned_word.sql';
      case CreateTableStatement.wordHint:
        return 'assets/sql/ddl/create/create_table_word_hint.sql';
      case CreateTableStatement.purchaseHistory:
        return 'assets/sql/ddl/create/create_table_purchase_history.sql';
      case CreateTableStatement.folder:
        return 'assets/sql/ddl/create/create_table_folder.sql';
      case CreateTableStatement.folderItem:
        return 'assets/sql/ddl/create/create_table_folder_item.sql';
      case CreateTableStatement.learnedWordSentence:
        return 'assets/sql/ddl/create/create_table_learned_word_sentence.sql';
      case CreateTableStatement.tipAndNote:
        return 'assets/sql/ddl/create/create_table_tip_and_note.sql';
    }
  }
}
