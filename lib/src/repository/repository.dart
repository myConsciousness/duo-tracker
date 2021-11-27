// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Package imports:
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

// Project imports:
import 'package:duo_tracker/src/repository/database_provider.dart';

abstract class Repository<T> {
  /// The database provider.
  final database = DatabaseProvider.getInstance().database;

  /// Returns the table name.
  String get table;

  /// Returns all records.
  Future<List<T>> findAll();

  /// Returns the unique model linked to the [id] passed as an argument.
  Future<T> findById(int id);

  /// Returns the count of records.
  Future<int?> count() async {
    return Sqflite.firstIntValue(await database.then((Database database) =>
        database.rawQuery('SELECT COUNT(*) FROM $table;')));
  }

  /// Inserts the [model] and returns the new [model] with autoincremented id.
  Future<T> insert(T model);

  /// Updates the record based on the [model] passed as an argument.
  void update(T model);

  /// Deletes the [model].
  void delete(T model);

  /// Deletes all records.
  Future<void> deleteAll();

  /// Replaces the [model] and returns the new [model] with autoincremented id.
  Future<T> replace(T model);
}
