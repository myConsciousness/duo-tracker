// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/repository/chart_repository.dart';
import 'package:duo_tracker/src/repository/model/chart_data_source_mode.dart';

class ChartService extends ChartRepository {
  /// The internal constructor.
  ChartService._internal();

  /// Returns the singleton instance of [ChartService].
  factory ChartService.getInstance() => _singletonInstance;

  /// The singleton instance of this [CourseService].
  static final _singletonInstance = ChartService._internal();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<void> delete(ChartDataSource model) async =>
      throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<void> deleteAll() async => throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<List<ChartDataSource>> findAll() async => throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<ChartDataSource> findById(int id) async => throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<ChartDataSource> insert(ChartDataSource model) async =>
      throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<ChartDataSource> replace(ChartDataSource model) async =>
      throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  String get table => throw UnimplementedError();

  @override
  @Deprecated(
      'Since this service class is used to perform aggregation from already persisted data, it has no way to persist specific data.')
  Future<void> update(ChartDataSource model) async =>
      throw UnimplementedError();

  @override
  Future<List<ChartDataSource>> computeLearningScoreRatioByTargets({
    required double targetXpPerDay,
    required double targetWeeklyXp,
    required double targetMontlyXp,
    required double targetStreak,
  }) async {
    return await super.database.then(
          (database) => database.rawQuery("""
              SELECT
                'Daily XP' X_VALUE,
                ROUND(((WEEKLY_XP / 7.0) / $targetXpPerDay) * 100, 2) Y_VALUE,
                69 COLOR_R,
                186 COLOR_G,
                161 COLOR_B,
                1.0 COLOR_O
              FROM
                USER
              UNION ALL
              SELECT
                'Weekly XP' X_VALUE,
                ROUND((WEEKLY_XP / $targetWeeklyXp) * 100, 2) Y_VALUE,
                230 COLOR_R,
                135 COLOR_G,
                111 COLOR_B,
                1.0 COLOR_O
              FROM
                USER
              UNION ALL
              SELECT
                'Monthly XP' X_VALUE,
                ROUND((MONTHLY_XP / $targetMontlyXp) * 100, 2) Y_VALUE,
                145 COLOR_R,
                132 COLOR_G,
                202 COLOR_B,
                1.0 COLOR_O
              FROM
                USER
              UNION ALL
              SELECT
                'Streak' X_VALUE,
                ROUND((STREAK / $targetStreak) * 100, 2) Y_VALUE,
                235 COLOR_R,
                96 COLOR_G,
                143 COLOR_B,
                1.0 COLOR_O
              FROM
                USER""").then(
            (dataSources) => dataSources
                .map((dataSource) => ChartDataSource.fromMap(dataSource))
                .toList(),
          ),
        );
  }
}
