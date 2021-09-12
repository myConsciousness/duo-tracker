// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/learned_word_repository.dart';
import 'package:duo_tracker/src/repository/model/learned_word_model.dart';
import 'package:duo_tracker/src/repository/service/word_hint_service.dart';

class LearnedWordService extends LearnedWordRepository {
  /// The internal constructor.
  LearnedWordService._internal();

  /// Returns the singleton instance of [LearnedWordService].
  factory LearnedWordService.getInstance() => _singletonInstance;

  /// The singleton instance of this [LearnedWordService].
  static final _singletonInstance = LearnedWordService._internal();

  /// The word hint service
  final _wordHintService = WordHintService.getInstance();

  @override
  Future<void> delete(LearnedWord model) async => await super.database.then(
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
  Future<void> deleteByWordIdAndUserId(
    String wordId,
    String userId,
  ) async =>
      await super.database.then(
            (database) => database.delete(
              table,
              where: 'WORD_ID = ? AND USER_ID = ?',
              whereArgs: [
                wordId,
                userId,
              ],
            ),
          );

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
  Future<List<LearnedWord>> findByUserIdAndLearningLanguageAndFromLanguage(
    String userId,
    String learningLanguage,
    String fromLanguage,
  ) async {
    final learedWords = await super.database.then(
          (database) => database
              .query(
                table,
                where:
                    'USER_ID = ? AND LEARNING_LANGUAGE = ? AND FROM_LANGUAGE = ?',
                whereArgs: [
                  userId,
                  learningLanguage,
                  fromLanguage,
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
      learnedWord.wordHints = await _wordHintService.findByWordIdAndUserId(
          learnedWord.wordId, userId);
    }

    return learedWords;
  }

  @override
  Future<LearnedWord> findByWordIdAndUserId(
          String wordId, String userId) async =>
      await super.database.then(
            (database) => database.query(
              table,
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
  Future<LearnedWord> insert(LearnedWord model) async {
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
  Future<LearnedWord> replace(LearnedWord model) async {
    await delete(model);
    return await insert(model);
  }

  @override
  Future<LearnedWord> replaceById(LearnedWord learnedWord) async {
    LearnedWord storedLearnedWord = await findByWordIdAndUserId(
      learnedWord.wordId,
      learnedWord.userId,
    );

    if (storedLearnedWord.isEmpty()) {
      storedLearnedWord = await insert(learnedWord);

      // Update sort order as id
      storedLearnedWord.sortOrder = storedLearnedWord.id;
      await update(storedLearnedWord);
    } else {
      learnedWord.id = storedLearnedWord.id;
      learnedWord.bookmarked = storedLearnedWord.bookmarked;
      learnedWord.completed = storedLearnedWord.completed;
      learnedWord.deleted = storedLearnedWord.deleted;
      learnedWord.sortOrder = storedLearnedWord.sortOrder;
      learnedWord.createdAt = storedLearnedWord.createdAt;

      await update(learnedWord);
    }

    return storedLearnedWord;
  }

  @override
  Future<void> replaceSortOrdersByIds(List<LearnedWord> learnedWords) async {
    learnedWords.asMap().forEach((index, learnedWord) async {
      LearnedWord storedLearnedWord = await findByWordIdAndUserId(
        learnedWord.wordId,
        learnedWord.userId,
      );

      storedLearnedWord.sortOrder = index;
      storedLearnedWord.updatedAt = DateTime.now();

      update(storedLearnedWord);
    });
  }

  @override
  String get table => 'LEARNED_WORD';

  @override
  Future<void> update(LearnedWord model) async => await super.database.then(
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
