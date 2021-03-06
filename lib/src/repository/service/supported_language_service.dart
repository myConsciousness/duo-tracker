// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/supported_language_model.dart';
import 'package:duo_tracker/src/repository/supported_language_repository.dart';

class SupportedLanguageService extends SupportedLanguageRepository {
  /// The internal constructor.
  SupportedLanguageService._internal();

  /// Returns the singleton instance of [SupportedLanguageService].
  factory SupportedLanguageService.getInstance() => _singletonInstance;

  /// The singleton instance of this [SupportedLanguageService].
  static final _singletonInstance = SupportedLanguageService._internal();

  @override
  Future<void> delete(SupportedLanguage model) async =>
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
  Future<List<SupportedLanguage>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? SupportedLanguage.fromMap(e)
                        : SupportedLanguage.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<List<SupportedLanguage>> findByFromLanguage(
          {required String fromLanguage}) async =>
      await super.database.then(
            (database) => database.query(
              table,
              where: 'FROM_LANGUAGE = ?',
              whereArgs: [
                fromLanguage,
              ],
            ).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? SupportedLanguage.fromMap(e)
                        : SupportedLanguage.empty(),
                  )
                  .toList(),
            ),
          );

  @override
  Future<SupportedLanguage> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? SupportedLanguage.fromMap(entity[0])
              : SupportedLanguage.empty(),
        ),
      );

  @override
  Future<SupportedLanguage> insert(SupportedLanguage model) async {
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
  Future<SupportedLanguage> replace(SupportedLanguage model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  String get table => 'SUPPORTED_LANGUAGE';

  @override
  Future<void> update(SupportedLanguage model) async =>
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

  @override
  Future<List<String>> findDistinctFromLanguages() async =>
      await super.database.then(
            (database) => database.rawQuery(
              '''
            select distinct
              SL.FROM_LANGUAGE
            from
              $table SL inner join COURSE C
              on SL.FORMAL_FROM_LANGUAGE = C.FORMAL_FROM_LANGUAGE AND SL.FORMAL_LEARNING_LANGUAGE = C.FORMAL_LEARNING_LANGUAGE
            ;
            ''',
            ).then(
              (entities) => entities
                  .map(
                    (entity) => entity['FROM_LANGUAGE'] as String,
                  )
                  .toList(),
            ),
          );

  @override
  Future<List<String>> findDistinctLearningLanguagesByFormalFromLanguage({
    required String formalFromLanguage,
  }) async =>
      await super.database.then(
            (database) => database.rawQuery(
              '''
            select distinct
              SL.LEARNING_LANGUAGE
            from
              $table SL inner join COURSE C
              on SL.FORMAL_FROM_LANGUAGE = C.FORMAL_FROM_LANGUAGE AND SL.FORMAL_LEARNING_LANGUAGE = C.FORMAL_LEARNING_LANGUAGE
            where
              SL.FORMAL_FROM_LANGUAGE = ?
            ;
            ''',
              [
                formalFromLanguage,
              ],
            ).then(
              (entities) => entities
                  .map(
                    (entity) => entity['LEARNING_LANGUAGE'] as String,
                  )
                  .toList(),
            ),
          );
}
