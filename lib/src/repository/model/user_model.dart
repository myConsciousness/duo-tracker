// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class User {
  int id = -1;
  String userId;
  String name;
  String bio;
  String plusStatus;
  String inviteUrl;
  String pictureUrl;
  String timeZone;
  String currentCourseId;
  String learningLanguage;
  String fromLanguage;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// The flag that represents if this model is exist
  bool _empty = false;

  /// Returns the empty instance of [User].
  User.empty()
      : _empty = true,
        userId = '',
        name = '',
        bio = '',
        plusStatus = '',
        inviteUrl = '',
        pictureUrl = '',
        timeZone = '',
        currentCourseId = '',
        learningLanguage = '',
        fromLanguage = '';

  /// Returns the new instance of [User] based on the parameters.
  User.from({
    this.id = -1,
    required this.userId,
    required this.name,
    required this.bio,
    required this.plusStatus,
    required this.inviteUrl,
    required this.pictureUrl,
    required this.timeZone,
    required this.currentCourseId,
    required this.learningLanguage,
    required this.fromLanguage,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the new instance of [User] based on the [map] passed as an argument.
  factory User.fromMap(Map<String, dynamic> map) => User.from(
        id: map[_ColumnName.id],
        userId: map[_ColumnName.userId],
        name: map[_ColumnName.name],
        bio: map[_ColumnName.bio],
        plusStatus: map[_ColumnName.plusStatus],
        inviteUrl: map[_ColumnName.inviteUrl],
        pictureUrl: map[_ColumnName.pictureUrl],
        timeZone: map[_ColumnName.timeZone],
        currentCourseId: map[_ColumnName.currentCourseId],
        learningLanguage: map[_ColumnName.learningLanguage],
        fromLanguage: map[_ColumnName.fromLanguage],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.createdAt] ?? 0,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[_ColumnName.updatedAt] ?? 0,
        ),
      );

  /// Returns this [User] model as [Map].
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[_ColumnName.userId] = userId;
    map[_ColumnName.name] = name;
    map[_ColumnName.bio] = bio;
    map[_ColumnName.plusStatus] = plusStatus;
    map[_ColumnName.inviteUrl] = inviteUrl;
    map[_ColumnName.pictureUrl] = pictureUrl;
    map[_ColumnName.timeZone] = timeZone;
    map[_ColumnName.currentCourseId] = currentCourseId;
    map[_ColumnName.learningLanguage] = learningLanguage;
    map[_ColumnName.fromLanguage] = fromLanguage;
    map[_ColumnName.createdAt] = createdAt.millisecondsSinceEpoch;
    map[_ColumnName.updatedAt] = updatedAt.millisecondsSinceEpoch;
    return map;
  }

  /// Returns [true] if this model is empty, otherwise [false].
  bool isEmpty() => _empty;
}

/// The internal const class that manages the column name of [User] repository.
class _ColumnName {
  static const id = 'ID';
  static const userId = 'USER_ID';
  static const name = 'NAME';
  static const bio = 'BIO';
  static const plusStatus = 'PLUS_STATUS';
  static const inviteUrl = 'INVITE_URL';
  static const pictureUrl = 'PICTURE_URL';
  static const timeZone = 'TIME_ZONE';
  static const currentCourseId = 'CURRENT_COURSE_ID';
  static const learningLanguage = 'LEARNING_LANGUAGE';
  static const fromLanguage = 'FROM_LANGUAGE';
  static const createdAt = 'CREATED_AT';
  static const updatedAt = 'UPDATED_AT';
}
