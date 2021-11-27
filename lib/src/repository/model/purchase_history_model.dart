// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/const/column/purchase_history_column.dart';

class PurchaseHistory {
  int id = -1;
  String productName;
  int price;
  int priceType;
  int validPeriodInMinutes;
  DateTime purchasedAt;
  DateTime expiredAt;
  DateTime createdAt;
  DateTime updatedAt;

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [PurchaseHistory].
  PurchaseHistory.empty()
      : _empty = true,
        productName = '',
        price = -1,
        priceType = -1,
        validPeriodInMinutes = -1,
        purchasedAt = DateTime.now(),
        expiredAt = DateTime.now(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  /// Returns the new instance of [PurchaseHistory] based on the parameters.
  PurchaseHistory.from({
    this.id = -1,
    required this.productName,
    required this.price,
    required this.priceType,
    required this.validPeriodInMinutes,
    required this.purchasedAt,
    required this.expiredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [PurchaseHistory] based on the [map] passed as an argument.
  factory PurchaseHistory.fromMap(Map<String, dynamic> map) =>
      PurchaseHistory.from(
        id: map[PurchaseHistoryColumn.id],
        productName: map[PurchaseHistoryColumn.productName],
        price: map[PurchaseHistoryColumn.price],
        priceType: map[PurchaseHistoryColumn.priceType],
        validPeriodInMinutes: map[PurchaseHistoryColumn.validPeriodInMinutes],
        purchasedAt: DateTime.fromMillisecondsSinceEpoch(
          map[PurchaseHistoryColumn.purchasedAt] ?? 0,
        ),
        expiredAt: DateTime.fromMillisecondsSinceEpoch(
          map[PurchaseHistoryColumn.expiredAt] ?? 0,
        ),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[PurchaseHistoryColumn.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[PurchaseHistoryColumn.updatedAt] ?? 0,
        ),
      );

  /// Returns this [PurchaseHistory] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[PurchaseHistoryColumn.productName] = productName;
    map[PurchaseHistoryColumn.price] = price;
    map[PurchaseHistoryColumn.priceType] = priceType;
    map[PurchaseHistoryColumn.validPeriodInMinutes] = validPeriodInMinutes;
    map[PurchaseHistoryColumn.purchasedAt] = purchasedAt.millisecondsSinceEpoch;
    map[PurchaseHistoryColumn.expiredAt] = expiredAt.millisecondsSinceEpoch;
    map[PurchaseHistoryColumn.createdAt] = createdAt.millisecondsSinceEpoch;
    map[PurchaseHistoryColumn.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}
