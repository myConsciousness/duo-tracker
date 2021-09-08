// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/boolean_text.dart';
import 'package:duovoc/src/repository/learned_word_repository.dart';
import 'package:duovoc/src/repository/model/learned_word_model.dart';
import 'package:duovoc/src/repository/service/word_hint_service.dart';

class LearnedWordService extends LearnedWordRepository {
  /// The singleton instance of this [LearnedWordService].
  static final _singletonInstance = LearnedWordService._internal();

  /// The internal constructor.
  LearnedWordService._internal();

  /// Returns the singleton instance of [LearnedWordService].
  factory LearnedWordService.getInstance() => _singletonInstance;

  /// The word hint service
  final _wordHintService = WordHintService.getInstance();

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
  Future<List<LearnedWord>> findByUserIdAndNotCompletedAndNotDeleted(
    String userId,
  ) async {
    final learedWords = await super.database.then(
          (database) => database
              .query(
                this.table,
                where: 'USER_ID = ? AND COMPLETED = ? AND DELETED = ?',
                whereArgs: [
                  userId,
                  BooleanText.FALSE,
                  BooleanText.FALSE,
                ],
                orderBy: 'SORT_ORDER',
              )
              .then(
                (entities) => entities
                    .map((entity) => entity.isNotEmpty
                        ? LearnedWord.fromMap(entity)
                        : LearnedWord.empty())
                    .toList(),
              ),
        );

    for (final LearnedWord learnedWord in learedWords) {
      learnedWord.wordHints = await this
          ._wordHintService
          .findByWordIdAndUserId(learnedWord.wordId, userId);
    }

    return learedWords;
  }

  @override
  Future<void> deleteByWordIdAndUserId(
    String wordId,
    String userId,
  ) async =>
      await super.database.then(
            (database) => database.delete(
              this.table,
              where: 'WORD_ID = ? AND USER_ID = ?',
              whereArgs: [
                wordId,
                userId,
              ],
            ),
          );

  @override
  Future<LearnedWord> findByWordIdAndUserId(
          String wordId, String userId) async =>
      await super.database.then(
            (database) => database.query(
              this.table,
              where: 'WORD_ID = ? AND USER_ID = ?',
              whereArgs: [
                wordId,
                userId,
              ],
            ).then(
              (entity) => entity.isNotEmpty
                  ? LearnedWord.fromMap(entity[0])
                  : LearnedWord.empty(),
            ),
          );

  @override
  Future<LearnedWord> replaceById(LearnedWord learnedWord) async {
    LearnedWord storedLearnedWord = await this.findByWordIdAndUserId(
      learnedWord.wordId,
      learnedWord.userId,
    );

    if (storedLearnedWord.isEmpty()) {
      storedLearnedWord = await this.insert(learnedWord);

      // Update sort order as id
      storedLearnedWord.sortOrder = storedLearnedWord.id;
      await this.update(storedLearnedWord);
    } else {
      learnedWord.id = storedLearnedWord.id;
      learnedWord.bookmarked = storedLearnedWord.bookmarked;
      learnedWord.completed = storedLearnedWord.completed;
      learnedWord.deleted = storedLearnedWord.deleted;
      learnedWord.sortOrder = storedLearnedWord.sortOrder;
      learnedWord.createdAt = storedLearnedWord.createdAt;

      await this.update(learnedWord);
    }

    return storedLearnedWord;
  }

  @override
  Future<void> replaceSortOrdersByIds(List<LearnedWord> learnedWords) async {
    learnedWords.asMap().forEach((index, learnedWord) async {
      LearnedWord storedLearnedWord = await this.findByWordIdAndUserId(
        learnedWord.wordId,
        learnedWord.userId,
      );

      storedLearnedWord.sortOrder = index;
      storedLearnedWord.updatedAt = DateTime.now();

      this.update(storedLearnedWord);
    });
  }
}
