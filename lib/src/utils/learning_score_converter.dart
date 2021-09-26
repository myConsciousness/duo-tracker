// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class LearningScoreConverter {
  static String toScoreName({
    required int score,
  }) {
    if (score >= 100) {
      return 'SSS';
    } else if (score >= 95) {
      return 'SS+';
    } else if (score >= 90) {
      return 'SS-';
    } else if (score >= 85) {
      return 'S+';
    } else if (score >= 80) {
      return 'S-';
    } else if (score >= 75) {
      return 'A+';
    } else if (score >= 70) {
      return 'A-';
    } else if (score >= 65) {
      return 'B+';
    } else if (score >= 60) {
      return 'B-';
    } else if (score >= 55) {
      return 'C+';
    } else if (score >= 50) {
      return 'C-';
    }

    return 'D';
  }

  static int toScore({
    required double achievement,
  }) {
    if (achievement >= 100.0) {
      return 40;
    } else if (achievement >= 90.0) {
      return 35;
    } else if (achievement >= 80.0) {
      return 30;
    } else if (achievement >= 70.0) {
      return 25;
    } else if (achievement >= 60.0) {
      return 20;
    } else if (achievement >= 50.0) {
      return 15;
    } else if (achievement >= 40.0) {
      return 10;
    } else if (achievement >= 30.0) {
      return 5;
    }

    return 0;
  }
}
