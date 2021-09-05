// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/learned_word_repository.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';

class LearnedWordService extends LearnedWordRepository {
  /// The singleton instance of this [LearnedWordService].
  static final _singletonInstance = LearnedWordService._internal();

  /// The internal constructor.
  LearnedWordService._internal();

  /// Returns the singleton instance of [LearnedWordService].
  factory LearnedWordService.getInstance() => _singletonInstance;

  @override
  String get table => 'LEARNED_WORD';

  @override
  Future<List<LearnedWord>> findAll() async => await super.database.then(
        (database) => database.query(table).then(
              (v) => v
                  .map(
                    (e) => e.isNotEmpty
                        ? LearnedWord.fromMap(e)
                        : LearnedWord.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<LearnedWord> findById(int id) async => await super.database.then(
        (database) =>
            database.query(table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? LearnedWord.fromMap(entity[0])
              : LearnedWord.empty(),
        ),
      );

  @override
  Future<LearnedWord> insert(LearnedWord learnedWord) async {
    await super.database.then(
          (database) => database
              .insert(table, learnedWord.toMap())
              .then((id) => learnedWord.id = id),
        );

    return learnedWord;
  }

  @override
  void update(LearnedWord learnedWord) async => await super.database.then(
        (database) => database.update(
          table,
          learnedWord.toMap(),
          where: 'ID = ?',
          whereArgs: [learnedWord.id],
        ),
      );

  @override
  void delete(LearnedWord learnedWord) async => await super.database.then(
        (database) => database.delete(
          table,
          where: 'ID = ?',
          whereArgs: [learnedWord.id],
        ),
      );

  @override
  Future<LearnedWord> replace(LearnedWord learnedWord) async {
    this.delete(learnedWord);
    return await this.insert(learnedWord);
  }

  @override
  Future<List<LearnedWord>> findByNotBookmarkedAndNotDeleted() async =>
      await super.database.then(
            (database) => database
                .query(
                  table,
                  where:
                      'HISTORY_TYPE = ? AND HISTORY_SUB_TYPE = ? AND DELETED = ?',
                  whereArgs: [],
                  orderBy: 'CREATED_AT DESC',
                )
                .then(
                  (entities) => entities
                      .map((entity) => entity.isNotEmpty
                          ? LearnedWord.fromMap(entity)
                          : LearnedWord.empty())
                      .toList(),
                ),
          );

  @override
  Future<void> deleteByWordId(LearnedWord learnedWord) async =>
      await super.database.then(
            (database) => database.delete(
              table,
              where: 'WORD_ID = ?',
              whereArgs: [learnedWord.wordId],
            ),
          );

  @override
  Future<LearnedWord> replaceByWordId(LearnedWord learnedWord) async {
    this.deleteByWordId(learnedWord);
    return await this.insert(learnedWord);
  }
}
