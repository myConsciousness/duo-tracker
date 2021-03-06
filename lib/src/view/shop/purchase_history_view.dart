// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/admob/banner_ad_list.dart';
import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/common_card_header_text.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/purchase_history_model.dart';
import 'package:duo_tracker/src/repository/service/purchase_history_service.dart';
import 'package:duo_tracker/src/utils/date_time_formatter.dart';
import 'package:duo_tracker/src/view/shop/purchase_history_tab_type.dart';

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
  /// The banner ad list
  final _bannerAdList = BannerAdList.newInstance();

  /// The date time formatter
  final _dateTimeFormatter = DateTimeFormatter();

  /// The purchase history service
  final _purchaseHistoryService = PurchaseHistoryService.getInstance();

  @override
  void dispose() {
    _bannerAdList.dispose();
    super.dispose();
  }

  Future<List<PurchaseHistory>> _fetchDataSource() {
    switch (widget.purchaseHistoryTabType) {
      case PurchaseHistoryTabType.valid:
        return _purchaseHistoryService.findAllValid();
      case PurchaseHistoryTabType.expired:
        return _purchaseHistoryService.findAllExpired();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: const Center(
            child: Text(
              'Purchase History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          body: FutureBuilder(
            future: _fetchDataSource(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<PurchaseHistory> purchaseHistories = snapshot.data;

              if (purchaseHistories.isEmpty) {
                return const Center(
                  child: Text('No Data'),
                );
              }

              return ListView.builder(
                itemCount: purchaseHistories.length,
                itemBuilder: (BuildContext context, int index) {
                  final purchaseHistory = purchaseHistories[index];
                  return Column(
                    children: [
                      FutureBuilder(
                        future: BannerAdUtils.canShow(
                          index: index,
                          interval: 3,
                        ),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData || !snapshot.data) {
                            return Container();
                          }

                          return BannerAdUtils.createBannerAdWidget(
                            _bannerAdList.loadNewBanner(),
                          );
                        },
                      ),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                            bottom: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonCardHeaderText(
                                    title:
                                        '${purchaseHistory.validPeriodInMinutes} min',
                                    subtitle: 'Valid Period',
                                  ),
                                  FutureBuilder(
                                    future: _dateTimeFormatter.execute(
                                        dateTime: purchaseHistory.purchasedAt),
                                    builder: (_, AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Loading();
                                      }

                                      return CommonCardHeaderText(
                                        subtitle: 'Purchased At',
                                        title: snapshot.data,
                                      );
                                    },
                                  ),
                                  FutureBuilder(
                                    future: _dateTimeFormatter.execute(
                                        dateTime: purchaseHistory.expiredAt),
                                    builder: (_, AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Loading();
                                      }

                                      return CommonCardHeaderText(
                                        subtitle: 'Expired At',
                                        title: snapshot.data,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const CommonDivider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.gpp_good,
                                        color: widget.purchaseHistoryTabType ==
                                                PurchaseHistoryTabType.valid
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Colors.grey,
                                      ),
                                      title: Text(
                                        'Product Name',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        purchaseHistory.productName,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${purchaseHistory.price} Points',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
}
