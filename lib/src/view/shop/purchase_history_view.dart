// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/view/shop/purchase_history_tab_type.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryView extends StatefulWidget {
  const PurchaseHistoryView({
    Key? key,
    required this.purchaseHistoryTabType,
  }) : super(key: key);

  /// The purchase history tab type
  final PurchaseHistoryTabType purchaseHistoryTabType;

  @override
  _PurchaseHistoryViewState createState() => _PurchaseHistoryViewState();
}

class _PurchaseHistoryViewState extends State<PurchaseHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
