// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// Project imports:
import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/chart/tracker_column_chart.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_divider.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/service/chart_service.dart';
import 'package:duo_tracker/src/view/analysis/proficiency_range.dart';

class ProficiencyAnalysisView extends StatefulWidget {
  const ProficiencyAnalysisView({Key? key}) : super(key: key);

  @override
  _ProficiencyAnalysisViewState createState() =>
      _ProficiencyAnalysisViewState();
}

class _ProficiencyAnalysisViewState extends State<ProficiencyAnalysisView> {
  /// The app bar title
  final String _appBatTitle = 'Skill Analysis';

  /// The chart service
  final _chartService = ChartService.getInstance();

  /// The header banner ad
  late BannerAd _headerBannerAd;

  /// The selected bar count
  int _selectedBarCount = 10;

  /// The selected proficiency range
  SfRangeValues _selectedProficiencyRange = const SfRangeValues(10.0, 50.0);

  @override
  void dispose() {
    _headerBannerAd.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _headerBannerAd = BannerAdUtils.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(title: _appBatTitle),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: BannerAdUtils.canShow(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || !snapshot.data) {
                        return Container();
                      }

                      return BannerAdUtils.createBannerAdWidget(
                        _headerBannerAd,
                      );
                    },
                  ),
                  SizedBox(
                    height: 350,
                    child: FutureBuilder(
                      future: _chartService
                          .computeSkillProficiencyByProficiencyRangeAndLimit(
                        proficiencyRange: ProficiencyRange.from(
                          from: _selectedProficiencyRange.start / 100,
                          to: _selectedProficiencyRange.end / 100,
                        ),
                        limit: _selectedBarCount,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Loading();
                        }

                        return TrackerColumnChart(
                          chartTitle: ChartTitle(
                            text: 'Proficiency',
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartDataSources: snapshot.data,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            canShowMarker: true,
                            header: 'Proficiency',
                            format: 'point.x : point.y',
                          ),
                          seriesName: '',
                          showLegend: false,
                        );
                      },
                    ),
                  ),
                  const CommonDivider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'Proficiency Range',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SfRangeSlider(
                        values: _selectedProficiencyRange,
                        min: 0.0,
                        max: 100.0,
                        showTicks: true,
                        showLabels: true,
                        interval: 10.0,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: (range) {
                          super.setState(() {
                            _selectedProficiencyRange = range;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'Bars',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SfSlider(
                        min: 0.0,
                        max: 100.0,
                        value: _selectedBarCount,
                        showTicks: true,
                        showLabels: true,
                        interval: 10.0,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (value) {
                          super.setState(() {
                            _selectedBarCount = (value as double).toInt();
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
