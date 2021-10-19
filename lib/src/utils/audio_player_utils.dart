// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtils {
  /// The audio player
  static final _audioPlayer = AudioPlayer();

  static Future<void> play({
    required List<String> ttsVoiceUrls,
  }) async {
    for (final ttsVoiceUrl in ttsVoiceUrls) {
      // Play all voices.
      // Requires a time to wait for each word to play.
      await _audioPlayer.play(ttsVoiceUrl, volume: 2.0);
      await Future.delayed(const Duration(seconds: 1), () {});
    }

    // Wait while playing audio
    await Future.delayed(const Duration(seconds: 1), () {});
  }
}
