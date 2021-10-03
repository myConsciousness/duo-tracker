// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/purchase_history_model.dart';
import 'package:duo_tracker/src/repository/purchase_history_repository.dart';

class PurchaseHistoryService extends PurchaseHistoryRepository {
  /// The internal constructor.
  PurchaseHistoryService._internal();

  /// Returns the singleton instance of [PurchaseHistoryService].
  factory PurchaseHistoryService.getInstance() => _singletonInstance;

  /// The singleton instance of this [PurchaseHistoryService].
  static final _singletonInstance = PurchaseHistoryService._internal();

  @override
  Future<void> delete(PurchaseHistory model) async => await super.database.then(
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
  Future<List<PurchaseHistory>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? PurchaseHistory.fromMap(e)
                        : PurchaseHistory.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<PurchaseHistory> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? PurchaseHistory.fromMap(entity[0])
              : PurchaseHistory.empty(),
        ),
      );

  @override
  Future<PurchaseHistory> insert(PurchaseHistory model) async {
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
  Future<PurchaseHistory> replace(PurchaseHistory model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'PURCHASE_HISTORY';

  @override
  Future<void> update(PurchaseHistory model) async => await super.database.then(
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
