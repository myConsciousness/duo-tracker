// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/model/voice_configuration_model.dart';
import 'package:duo_tracker/src/repository/voice_configuration_repository.dart';

class VoiceConfigurationService extends VoiceConfigurationRepository {
  VoiceConfigurationService._internal();

  /// Returns the singleton instance of [VoiceConfigurationService].
  factory VoiceConfigurationService.getInstance() => _singletonInstance;

  /// The internal constructor.
  /// The singleton instance of this [VoiceConfigurationService].
  static final _singletonInstance = VoiceConfigurationService._internal();

  @override
  Future<void> delete(VoiceConfiguration model) async =>
      await super.database.then(
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
  Future<List<VoiceConfiguration>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? VoiceConfiguration.fromMap(e)
                        : VoiceConfiguration.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<VoiceConfiguration> findById(int id) async =>
      await super.database.then(
            (database) =>
                database.query(table, where: 'ID = ?', whereArgs: [id]).then(
              (entity) => entity.isNotEmpty
                  ? VoiceConfiguration.fromMap(entity[0])
                  : VoiceConfiguration.empty(),
            ),
          );

  @override
  Future<VoiceConfiguration> insert(VoiceConfiguration model) async {
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
  Future<VoiceConfiguration> replace(VoiceConfiguration model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'VOICE_CONFIGURATION';

  @override
  Future<void> update(VoiceConfiguration model) async =>
      await super.database.then(
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
