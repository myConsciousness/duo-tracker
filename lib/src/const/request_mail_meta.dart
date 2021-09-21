// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class RequestMailMeta {
  /// The receipient address
  static const recipientAddress = 'kato.shinya.dev@gmail.com';

  /// The subject
  static const subject =
      '[DO NOT DELETE THIS SUBJECT] Request new feature or imporovement about Duo Tracker';

  /// The body
  static const body = '''・Request Summary
Please write request summary here...

・Request Detail
Please write request detail here...

-- ↓ Or if an error occurs while using the application ↓ --
・When it occurred?
Please write here...

・How to reproduce it?
Please write here...

・Do you get an error after several attempts?
[YES] or [NO]

・If you don't mind, what language are you learning?
Please write here if you're okay...
''';
}
