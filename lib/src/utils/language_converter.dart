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
        return 'Spanish (Espa??ol)';
      case 'fr':
        return 'French (Fran??ais)';
      case 'de':
        return 'German (Deutsch)';
      case 'it':
        return 'Italian (Italiano)';
      case 'ja':
        return 'Japanese (?????????)';
      case 'zs':
      case 'zh':
        return 'Chinese (??????)';
      case 'ru':
        return 'Russian (????????????????)';
      case 'ko':
        return 'Korean (?????????)';
      case 'pt':
        return 'Portuguese (Portugu??s)';
      case 'ar':
        return 'Arabic (??????????????????????????????)';
      case 'dn':
      case 'nl-NL':
        return 'Dutch (Nederlands)';
      case 'sv':
        return 'Swedish (Svenska)';
      case 'nb':
      case 'no-BO':
        return 'Norwegian (Bokm??l)';
      case 'tr':
        return 'Turkish (T??rk??e)';
      case 'pl':
        return 'Polish (Polski)';
      case 'ga':
        return 'Irish';
      case 'el':
        return 'Greek (????????????????)';
      case 'he':
        return 'Hebrew (??????????)';
      case 'da':
        return 'Danish (Dansk)';
      case 'hi':
        return 'Hindi (???????????????)';
      case 'cs':
        return 'Czech (??e??tina)';
      case 'eo':
        return 'Esperanto';
      case 'uk':
        return 'Ukrainian (????????????????????)';
      case 'cy':
        return 'Welsh';
      case 'vi':
        return 'Vietnamese (Vi???t)';
      case 'hu':
        return 'Hungarian (Magyar)';
      case 'sw':
        return 'Swahili (Kiswahili)';
      case 'ro':
        return 'Romanian (Rom??n??)';
      case 'id':
        return 'Indonesian (Indonesia)';
      case 'hw':
        return 'Hawaiian (Hawai??i)';
      case 'nv':
        return 'Navajo (Naabeeh??)';
      case 'kl':
      case 'tlh':
        return 'Klingon';
      case 'hv':
        return 'High Valyrian';
      case 'la':
        return 'Latin (Lat??num)';
      case 'gd':
        return 'Scottish Gaelic (G??idhlig)';
      case 'fi':
        return 'Finnish (Suomi)';
      case 'yi':
        return 'Yiddish (???????????????)';
      case 'th':
        return 'Thai (?????????????????????)';
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
