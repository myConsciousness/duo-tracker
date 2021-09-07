// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duovoc/src/repository/model/word_hint_model.dart';
import 'package:duovoc/src/repository/word_hint_repository.dart';

class WordHintService extends WordHintRepository {
  /// The singleton instance of this [WordHintService].
  static final _singletonInstance = WordHintService._internal();

  /// The internal constructor.
  WordHintService._internal();

  /// Returns the singleton instance of [WordHintService].
  factory WordHintService.getInstance() => _singletonInstance;

  @override
  String get table => 'WORD_HINT';

  @override
  Future<List<WordHint>> findAll() async => await super.database.then(
        (database) => database.query(this.table).then(
              (v) => v
                  .map(
                    (e) =>
                        e.isNotEmpty ? WordHint.fromMap(e) : WordHint.empty(),
                  )
                  .toList(),
            ),
      );

  @override
  Future<WordHint> findById(int id) async => await super.database.then(
        (database) =>
            database.query(this.table, where: 'ID = ?', whereArgs: [id]).then(
          (entity) => entity.isNotEmpty
              ? WordHint.fromMap(entity[0])
              : WordHint.empty(),
        ),
      );

  @override
  Future<WordHint> insert(WordHint wordHint) async {
    await super.database.then(
          (database) => database
              .insert(
                this.table,
                wordHint.toMap(),
              )
              .then(
                (int id) async => wordHint.id = id,
              ),
        );

    return wordHint;
  }

  @override
  Future<void> update(WordHint wordHint) async => await super.database.then(
        (database) => database.update(
          this.table,
          wordHint.toMap(),
          where: 'ID = ?',
          whereArgs: [
            wordHint.id,
          ],
        ),
      );

  @override
  Future<void> delete(WordHint wordHint) async => await super.database.then(
        (database) => database.delete(
          this.table,
          where: 'ID = ?',
          whereArgs: [wordHint.id],
        ),
      );

  @override
  Future<WordHint> replace(WordHint wordHint) async {
    await this.delete(wordHint);
    return await this.insert(wordHint);
  }
}
