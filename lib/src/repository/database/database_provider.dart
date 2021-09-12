// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/sql/create/table_definitions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  /// The internal constructor for singleton.
  DatabaseProvider._internal() : _database = _getDatabase();

  /// Returns the singleton instance of [DatabaseProvider].
  factory DatabaseProvider.getInstance() => _singletonInstance;

  /// The database name
  static const _databaseName = 'duo_tracker.db';

  /// The singleton instance of [DatabaseProvider].
  static final DatabaseProvider _singletonInstance =
      DatabaseProvider._internal();

  /// The database
  late final Future<Database> _database;

  /// Returns the database.
  Future<Database> get database => _database;

  /// Returns the  instance of database.
  static Future<Database> _getDatabase() async => await openDatabase(
        join(
          await getDatabasesPath(),
          _databaseName,
        ),
        onCreate: (Database database, int version) async {
          await database.execute(TableDefinitions.supportedLanguage);
          await database.execute(TableDefinitions.voiceConfiguration);
          await database.execute(TableDefinitions.user);
          await database.execute(TableDefinitions.skill);
          await database.execute(TableDefinitions.course);
          await database.execute(TableDefinitions.learnedWord);
          await database.execute(TableDefinitions.wordHint);
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          // Do nothing now
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) async {
          // Do nothing now
        },
        version: 1,
      );
}
