// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Project imports:
import 'package:duo_tracker/src/repository/model/course_model.dart';
import 'package:duo_tracker/src/repository/repository.dart';

abstract class CourseRepository extends Repository<Course> {
  Future<Course> findByCourseId({
    required String courseId,
  });

  Future<List<Course>> findAllOrderByFormalFromLanguageAndXpDesc();

  Future<void> insertAll({
    required List<Course> courses,
  });
}
