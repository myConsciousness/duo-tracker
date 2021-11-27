// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/utils/date_time_formatter.dart';

class CommonProductDetailCard extends StatelessWidget {
  CommonProductDetailCard({
    Key? key,
    required this.productName,
    required this.validPeriodInMinutes,
  }) : super(key: key);

  /// The date time formatter
  final _dateTimeFormatter = DateTimeFormatter();

  /// The product name
  final String productName;

  /// The valid period in minutes
  final int validPeriodInMinutes;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                subtitle: FutureBuilder(
                  future: _dateTimeFormatter.execute(
                    dateTime: DateTime.now().add(
                      Duration(minutes: validPeriodInMinutes),
                    ),
                  ),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Loading();
                    }

                    return Text('Expiration: ${snapshot.data}');
                  },
                ),
              ),
              const CommonDivider(),
              const Center(
                child: Text(
                  '* The expiration datetime is valid since its confirmed.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
