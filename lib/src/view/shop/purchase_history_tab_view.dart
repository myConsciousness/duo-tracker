// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_default_tab_controller.dart';
import 'package:duo_tracker/src/view/shop/purchase_history_tab_type.dart';
import 'package:duo_tracker/src/view/shop/purchase_history_view.dart';

class PurchaseHistoryTabView extends StatelessWidget {
  const PurchaseHistoryTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CommonDefaultTabController(
        length: 2,
        labelFontSize: 12.0,
        unselectedLabelFontSize: 11.0,
        tabs: [
          Tab(text: 'Valid'),
          Tab(text: 'Expired'),
        ],
        body: [
          PurchaseHistoryView(
            purchaseHistoryTabType: PurchaseHistoryTabType.valid,
          ),
          PurchaseHistoryView(
            purchaseHistoryTabType: PurchaseHistoryTabType.expired,
          ),
        ],
      );
}
