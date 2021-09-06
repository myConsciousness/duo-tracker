// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/sql/create/table_definitions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  /// The singleton instance of [DatabaseProvider].
  static final DatabaseProvider _singletonInstance =
      DatabaseProvider._internal();

  /// The database name
  static const String _DATABASE_NAME = 'duovoc.db';

  /// The database
  late final Future<Database> _database;

  /// The internal constructor for singleton.
  DatabaseProvider._internal() : this._database = _getDatabase();

  /// Returns the singleton instance of [DatabaseProvider].
  factory DatabaseProvider.getInstance() => _singletonInstance;

  /// Returns the database.
  Future<Database> get database => this._database;

  /// Returns the  instance of database.
  static Future<Database> _getDatabase() async => await openDatabase(
        join(
          await getDatabasesPath(),
          _DATABASE_NAME,
        ),
        onCreate: (Database database, int version) async {
          await database.execute(TableDefinitions.learnedWord);
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
