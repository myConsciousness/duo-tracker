// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/const/column/course_column_name.dart';
import 'package:duo_tracker/src/repository/course_repository.dart';
import 'package:duo_tracker/src/repository/model/course_model.dart';

class CourseService extends CourseRepository {
  /// The internal constructor.
  CourseService._internal();

  /// Returns the singleton instance of [CourseService].
  factory CourseService.getInstance() => _singletonInstance;

  /// The singleton instance of this [CourseService].
  static final _singletonInstance = CourseService._internal();

  @override
  Future<void> delete(Course model) async => await super.database.then(
        (database) => database.delete(
          table,
          where: 'ID = ?',
          whereArgs: [model.id],
        ),
      );

  @override
  Future<void> deleteAll() async => await super.database.then(
        (database) => database.delete(
          table,
        ),
      );

  @override
  Future<List<Course>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty ? Course.fromMap(e) : Course.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<Course> findByCourseId({required String courseId}) async => await super
      .database
      .then(
        (database) => database
            .query(table, where: 'COURSE_ID = ?', whereArgs: [courseId]).then(
          (entity) =>
              entity.isNotEmpty ? Course.fromMap(entity[0]) : Course.empty(),
        ),
      );

  @override
  Future<Course> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) =>
              entity.isNotEmpty ? Course.fromMap(entity[0]) : Course.empty(),
        ),
      );

  @override
  Future<Course> insert(Course model) async {
    await super.database.then(
          (database) => database
              .insert(
                table,
                model.toMap(),
              )
              .then(
                (int id) async => model.id = id,
              ),
        );

    return model;
  }

  @override
  Future<Course> replace(Course model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'COURSE';

  @override
  Future<void> update(Course model) async => await super.database.then(
        (database) => database.update(
          table,
          model.toMap(),
          where: 'ID = ?',
          whereArgs: [
            model.id,
          ],
        ),
      );

  @override
  Future<List<Course>> findAllOrderByFromLanguageAndXpDesc() async =>
      await super.database.then(
            (database) => database
                .query(
                  table,
                  orderBy:
                      '${CourseColumnName.fromLanguage}, ${CourseColumnName.xp} DESC',
                )
                .then(
                  (v) => v
                      .map(
                        (e) =>
                            e.isNotEmpty ? Course.fromMap(e) : Course.empty(),
                      )
                      .toList(),
                ),
          );
}
