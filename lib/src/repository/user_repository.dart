// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/user_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class UserRepository extends Repository<User> {
  Future<User> findByUserId({
    required String userId,
  });

  Future<void> updateByUserId({
    required User user,
  });

  Future<void> replaceByUserId({
    required User user,
  });
}
