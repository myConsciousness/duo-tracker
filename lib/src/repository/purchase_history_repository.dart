// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/purchase_history_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class PurchaseHistoryRepository extends Repository<PurchaseHistory> {
  Future<List<PurchaseHistory>> findAllValid();

  Future<List<PurchaseHistory>> findAllExpired();
}
