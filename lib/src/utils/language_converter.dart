// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class LanguageConverter {
  static String toName({
    required String languageCode,
  }) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'it':
        return 'Italian';
      case 'ja':
        return 'Japanese';
      case 'zs':
      case 'zh':
        return 'Chinese';
      case 'ru':
        return 'Russian';
      case 'ko':
        return 'Korean';
      case 'pt':
        return 'Portuguese';
      case 'ar':
        return 'Arabic';
      case 'dn':
      case 'nl-NL':
        return 'Dutch';
      case 'sv':
        return 'Swedish';
      case 'nb':
      case 'no-BO':
        return 'Norwegian';
      case 'tr':
        return 'Turkish';
      case 'pl':
        return 'Polish';
      case 'ga':
        return 'Irish';
      case 'el':
        return 'Greek';
      case 'he':
        return 'Hebrew';
      case 'da':
        return 'Danish';
      case 'hi':
        return 'Hindi';
      case 'cs':
        return 'Czech';
      case 'eo':
        return 'Esperanto';
      case 'uk':
        return 'Ukrainian';
      case 'cy':
        return 'Welsh';
      case 'vi':
        return 'Vietnamese';
      case 'hu':
        return 'Hungarian';
      case 'sw':
        return 'Swahili';
      case 'ro':
        return 'Romanian';
      case 'id':
        return 'Indonesian';
      case 'hw':
        return 'Hawaiian';
      case 'nv':
        return 'Navajo';
      case 'kl':
      case 'tlh':
        return 'Klingon';
      case 'hv':
        return 'High Valyrian';
      case 'la':
        return 'Latin';
      case 'gd':
        return 'Scottish Gaelic';
      case 'fi':
        return 'Finnish';
      case 'yi':
        return 'Yiddish';
      case 'th':
        return 'Thai';
      default:
        return 'N/A';
    }
  }

  static String toNameWithFormal({
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
      case 'zh':
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
      case 'nl-NL':
        return 'Dutch (Nederlands)';
      case 'sv':
        return 'Swedish (Svenska)';
      case 'nb':
      case 'no-BO':
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
      case 'tlh':
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

  static String toFormalLanguageCode({
    required String languageCode,
  }) {
    switch (languageCode) {
      case 'zs':
        return 'zh';
      case 'dn':
        return 'nl-NL';
      case 'nb':
        return 'no-BO';
      case 'kl':
        return 'tlh';
      default:
        return languageCode;
    }
  }
}
