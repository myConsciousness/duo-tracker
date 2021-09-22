// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Divider(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      );
}
