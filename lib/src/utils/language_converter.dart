// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class LanguageConverter {
  static String execute({
    required String languageCode,
  }) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish (Español)';
      case 'fr':
        return 'French (Français)';
      case 'de':
        return 'German (Deutsch)';
      case 'it':
        return 'Italian (Italiano)';
      case 'ja':
        return 'Japanese (日本語)';
      case 'zs':
        return 'Chinese (中文)';
      case 'ru':
        return 'Russian (Ру́сский)';
      case 'ko':
        return 'Korean (한국어)';
      case 'pt':
        return 'Portuguese (Português)';
      case 'ar':
        return 'Arabic (اَلْعَرَبِيَّةُ)';
      case 'dn':
        return 'Dutch (Nederlands)';
      case 'sv':
        return 'Swedish (Svenska)';
      case 'nb':
        return 'Norwegian (Bokmål)';
      case 'tr':
        return 'Turkish (Türkçe)';
      case 'pl':
        return 'Polish (Polski)';
      case 'ga':
        return 'Irish';
      case 'el':
        return 'Greek (Ελληνικά)';
      case 'he':
        return 'Hebrew (עברית)';
      case 'da':
        return 'Danish (Dansk)';
      case 'hi':
        return 'Hindi (हिंदी)';
      case 'cs':
        return 'Czech (Čeština)';
      case 'eo':
        return 'Esperanto';
      case 'uk':
        return 'Ukrainian (Українська)';
      case 'cy':
        return 'Welsh';
      case 'vi':
        return 'Vietnamese (Việt)';
      case 'hu':
        return 'Hungarian (Magyar)';
      case 'sw':
        return 'Swahili (Kiswahili)';
      case 'ro':
        return 'Romanian (Română)';
      case 'id':
        return 'Indonesian (Indonesia)';
      case 'hw':
        return 'Hawaiian (Hawaiʻi)';
      case 'nv':
        return 'Navajo (Naabeehó)';
      case 'kl':
        return 'Klingon';
      case 'hv':
        return 'High Valyrian';
      case 'la':
        return 'Latin (Latīnum)';
      case 'gd':
        return 'Scottish Gaelic (Gàidhlig)';
      case 'fi':
        return 'Finnish (Suomi)';
      case 'yi':
        return 'Yiddish (ייִדיש‎)';
      case 'th':
        return 'Thai (ภาษาไทย)';
      default:
        return 'N/A ($languageCode)';
    }
  }
}
