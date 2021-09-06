// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/boolean_text.dart';
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
        (database) => database.query(this.table).then(
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
            database.query(this.table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? LearnedWord.fromMap(entity[0])
              : LearnedWord.empty(),
        ),
      );

  @override
  Future<LearnedWord> insert(LearnedWord learnedWord) async {
    await super.database.then(
          (database) => database
              .insert(
                this.table,
                learnedWord.toMap(),
              )
              .then(
                (int id) async => learnedWord.id = id,
              ),
        );

    return learnedWord;
  }

  @override
  Future<void> update(LearnedWord learnedWord) async =>
      await super.database.then(
            (database) => database.update(
              this.table,
              learnedWord.toMap(),
              where: 'ID = ?',
              whereArgs: [
                learnedWord.id,
              ],
            ),
          );

  @override
  Future<void> delete(LearnedWord learnedWord) async =>
      await super.database.then(
            (database) => database.delete(
              this.table,
              where: 'ID = ?',
              whereArgs: [learnedWord.id],
            ),
          );

  @override
  Future<LearnedWord> replace(LearnedWord learnedWord) async {
    await this.delete(learnedWord);
    return await this.insert(learnedWord);
  }

  @override
  Future<List<LearnedWord>> findByNotBookmarkedAndNotDeleted() async {
    return await super.database.then(
          (database) => database
              .query(
                this.table,
                where: 'BOOKMARKED = ? AND DELETED = ?',
                whereArgs: [
                  BooleanText.FALSE,
                  BooleanText.FALSE,
                ],
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
  }

  @override
  Future<void> deleteByWordId(LearnedWord learnedWord) async =>
      await super.database.then(
            (database) => database.delete(
              this.table,
              where: 'WORD_ID = ?',
              whereArgs: [
                learnedWord.wordId,
              ],
            ),
          );

  @override
  Future<LearnedWord> replaceByWordId(LearnedWord learnedWord) async {
    await this.deleteByWordId(learnedWord);
    final newLearnedWord = await this.insert(learnedWord);

    // Update sort order as id
    newLearnedWord.sortOrder = newLearnedWord.id;
    await this.update(newLearnedWord);

    return newLearnedWord;
  }
}
