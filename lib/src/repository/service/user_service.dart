// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/user_repository.dart';

class UserService extends UserRepository {
  /// The internal constructor.
  UserService._internal();

  /// Returns the singleton instance of [UserService].
  factory UserService.getInstance() => _singletonInstance;

  /// The singleton instance of this [UserService].
  static final _singletonInstance = UserService._internal();

  @override
  Future<void> delete(User model) async => await super.database.then(
        (database) => database.delete(
          table,
          where: 'ID = ?',
          whereArgs: [model.id],
        ),
      );

  @override
  Future<List<User>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty ? User.fromMap(e) : User.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<User> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) =>
              entity.isNotEmpty ? User.fromMap(entity[0]) : User.empty(),
        ),
      );

  @override
  Future<User> findByUserId({required String userId}) async =>
      await super.database.then(
            (database) => database
                .query(table, where: 'USER_ID = ?', whereArgs: [userId]).then(
              (entity) =>
                  entity.isNotEmpty ? User.fromMap(entity[0]) : User.empty(),
            ),
          );

  @override
  Future<User> insert(User model) async {
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
  Future<User> replace(User model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'USER';

  @override
  Future<void> update(User model) async => await super.database.then(
        (database) => database.update(
          table,
          model.toMap(),
          where: 'ID = ?',
          whereArgs: [
            model.id,
          ],
        ),
      );
}
