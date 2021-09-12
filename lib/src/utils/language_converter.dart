// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class LanguageConverter {
  const LanguageConverter.from({
    required this.languageCode,
  });

  final String languageCode;

  String execute() {
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
        return 'Dutch';
      case 'sv':
        return 'Swedish';
      case 'nb':
        return 'Norwegian (Bokmål)';
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
      default:
        return 'N/A';
    }
  }
}
