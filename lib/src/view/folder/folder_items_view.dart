// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/admob/banner_ad_utils.dart';
import 'package:duo_tracker/src/component/common_app_bar_titles.dart';
import 'package:duo_tracker/src/component/common_learned_word_card.dart';
import 'package:duo_tracker/src/component/common_nested_scroll_view.dart';
import 'package:duo_tracker/src/component/const/folder_type.dart';
import 'package:duo_tracker/src/component/loading.dart';
import 'package:duo_tracker/src/repository/model/folder_item_model.dart';
import 'package:duo_tracker/src/repository/preference/common_shared_preferences_key.dart';
import 'package:duo_tracker/src/repository/service/folder_item_service.dart';
import 'package:duo_tracker/src/utils/audio_player_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FolderItemsView extends StatefulWidget {
  const FolderItemsView({
    Key? key,
    required this.folderType,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  /// The folder code
  final int folderId;

  /// The folder name
  final String folderName;

  /// The folder type
  final FolderType folderType;

  @override
  _FolderItemsViewState createState() => _FolderItemsViewState();
}

class _FolderItemsViewState extends State<FolderItemsView> {
  /// The banner ads
  final List<BannerAd> _bannerAds = <BannerAd>[];

  /// The folder item service
  final _folderItemService = FolderItemService.getInstance();

  late List<FolderItem> _folderItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (final bannerAd in _bannerAds) {
      bannerAd.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<FolderItem>> _fetchDataSource({
    required int folderId,
  }) async {
    final userId = await CommonSharedPreferencesKey.userId.getString();

    return await _folderItemService.findByFolderIdAndUserId(
      folderId: folderId,
      userId: userId,
    );
  }

  String get _appBarTitle {
    switch (widget.folderType) {
      case FolderType.none:
        throw UnimplementedError();
      case FolderType.word:
        return 'Words List';
      case FolderType.voice:
        return 'Voice Playlist';
    }
  }

  BannerAd _loadBannerAd() {
    final BannerAd bannerAd = BannerAdUtils.loadBannerAd();
    _bannerAds.add(bannerAd);
    return bannerAd;
  }

  Future<void> _sortCards({
    required List<FolderItem> folderItems,
    required int oldIndex,
    required int newIndex,
  }) async {
    folderItems.insert(
      oldIndex < newIndex ? newIndex - 1 : newIndex,
      folderItems.removeAt(oldIndex),
    );

    // Update all sort orders
    await _folderItemService.replaceSortOrdersByIds(
      folderItems: folderItems,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CommonNestedScrollView(
          title: CommonAppBarTitles(
            title: _appBarTitle,
            subTitle: 'Folder: ${widget.folderName}',
          ),
          actions: [
            if (widget.folderType == FolderType.voice)
              IconButton(
                icon: const Icon(Icons.play_circle),
                onPressed: () async {
                  for (final folderItem in _folderItems) {
                    await AudioPlayerUtils.play(
                      ttsVoiceUrls: folderItem.learnedWord!.ttsVoiceUrls,
                    );
                  }
                },
              ),
          ],
          body: FutureBuilder(
            future: _fetchDataSource(folderId: widget.folderId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }

              final List<FolderItem> items = snapshot.data;

              if (items.isEmpty) {
                return const Center(
                  child: Text('No Items'),
                );
              }

              _folderItems = List.from(items);

              return RefreshIndicator(
                onRefresh: () async {
                  super.setState(() {});
                },
                child: ReorderableListView.builder(
                  itemCount: items.length,
                  onReorder: (oldIndex, newIndex) async => await _sortCards(
                    folderItems: items,
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  ),
                  itemBuilder: (_, index) => Column(
                    key: Key('${items[index].sortOrder}'),
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
                              _loadBannerAd());
                        },
                      ),
                      CommonLearnedWordCard(
                        learnedWord: items[index].learnedWord!,
                        folderType: widget.folderType,
                        onPressedDeleteItem: () async {
                          await _folderItemService.delete(
                            items[index],
                          );

                          super.setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
