// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/sql/create_table_statement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

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
          for (final createTableStatement in CreateTableStatement.values) {
            await database.execute(
              await rootBundle.loadString(createTableStatement.path),
            );
          }
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
