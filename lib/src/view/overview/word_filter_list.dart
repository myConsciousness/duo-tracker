// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:duo_tracker/src/component/common_two_grids_radio_list_tile.dart';
import 'package:flutter/material.dart';

typedef ValidateSelectedItem<T> = bool Function(List<T>? list, T item);
typedef OnApplyButtonClick<T> = Function(List<T>? list);
typedef ChoiceChipBuilder<T> = Widget Function(
    BuildContext context, T? item, bool? iselected);
typedef LabelDelegate<T> = String? Function(T?);
typedef ValidateRemoveItem<T> = List<T> Function(List<T>? list, T item);

enum FilterItem {
  /// The lesson
  lesson,

  /// The strength
  strength,

  /// The pos
  pos,

  /// The infinitive
  infinitive,

  /// The gender
  gender,
}

class WordFilterList<T> extends StatefulWidget {
  const WordFilterList({
    Key? key,
    required this.listData,
    required this.selectedListData,
    required this.validateSelectedItem,
    required this.choiceChipLabel,
    required this.onApplyButtonClick,
    this.validateRemoveItem,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapSpacing = 0.0,
  }) : super(key: key);

  /// The `choiceChipLabel` is callback which required [String] value to display text on choice chip.
  final LabelDelegate<T> choiceChipLabel; /*required*/

  /// Pass list containing all data which neeeds to filter
  final List<T>? listData;

  /// The `onApplyButtonClick` is a callback which return list of all selected items on apply button click.  if no item is selected then it will return empty list.
  final OnApplyButtonClick<T>? onApplyButtonClick;

  /// The [selectedListData] is used to preselect the choice chips.
  /// It takes list of object and this list should be subset og [listData]
  final List<T>? selectedListData;

  /// The `validateRemoveItem` identifies if a item should be remove or not and returns the list filtered.
  final ValidateRemoveItem<T>? validateRemoveItem;

  /// The `validateSelectedItem` dentifies weather a item is selecte or not.
  final ValidateSelectedItem<T> validateSelectedItem; /*required*/

  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAxisAlignment;
  final double wrapSpacing;

  @override
  _WordFilterListState<T> createState() => _WordFilterListState<T>();
}

class _WordFilterListState<T> extends State<WordFilterList<T>> {
  bool showApplyButton = false;

  List<T>? _listData;
  List<T> _selectedListData = <T>[];

  @override
  void initState() {
    _listData = widget.listData == null ? <T>[] : List.from(widget.listData!);
    _selectedListData = widget.selectedListData == null
        ? <T>[]
        : List<T>.from(widget.selectedListData!);
    super.initState();
  }

  FilterItem _filterItem = FilterItem.lesson;

  Widget _body() => Column(
        children: <Widget>[
          const SizedBox(height: 25),
          CommonTwoGridsRadioListTile(
            label: 'Filter Pattern',
            dataSource: const {
              'Lesson': FilterItem.lesson,
              'Pos': FilterItem.pos,
              'Infinitive': FilterItem.infinitive,
              'Gender': FilterItem.gender,
              'Strength': FilterItem.strength,
            },
            groupValue: _filterItem,
            onChanged: (value) {
              super.setState(() {
                _filterItem = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Filter Item',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: widget.wrapAlignment,
                  crossAxisAlignment: widget.wrapCrossAxisAlignment,
                  spacing: widget.wrapSpacing,
                  children: _buildChoiceList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'selected ${_selectedListData.length} items',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          _buildButtons()
        ],
      );

  List<Widget> _buildChoiceList() {
    final List<Widget> choices = [];
    for (var item in _listData!) {
      var selectedText = widget.validateSelectedItem(_selectedListData, item);
      choices.add(
        _ChoiceChipWidget(
          item: item,
          onSelected: (value) {
            super.setState(() {
              if (selectedText) {
                if (widget.validateRemoveItem != null) {
                  var shouldDelete =
                      widget.validateRemoveItem!(_selectedListData, item);
                  _selectedListData = shouldDelete;
                } else {
                  _selectedListData.remove(item);
                }
              } else {
                _selectedListData.add(item);
              }
            });
          },
          selected: selectedText,
          text: widget.choiceChipLabel(item),
        ),
      );
    }

    choices.add(
      SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width,
      ),
    );

    return choices;
  }

  Widget _buildButtons() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  super.setState(() {
                    _selectedListData = List.from(_listData!);
                  });
                },
                child: const Text('All'),
              ),
              TextButton(
                onPressed: () {
                  super.setState(() {
                    _selectedListData.clear();
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: AnimatedButton(
              isFixedHeight: false,
              text: 'Apply',
              color: Theme.of(context).colorScheme.secondaryVariant,
              pressEvent: () {
                widget.onApplyButtonClick!(_selectedListData);
              },
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );
}

class _ChoiceChipWidget<T> extends StatelessWidget {
  const _ChoiceChipWidget({
    Key? key,
    this.text,
    this.item,
    this.selected,
    this.onSelected,
  }) : super(key: key);

  final String? text;
  final T? item;
  final bool? selected;
  final Function(bool)? onSelected;

  TextStyle _getSelectedTextStyle(BuildContext context) => selected!
      ? TextStyle(color: Theme.of(context).colorScheme.onSurface)
      : const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ChoiceChip(
          label: Text(
            '$text',
            style: _getSelectedTextStyle(context),
          ),
          selected: selected!,
          onSelected: onSelected,
        ),
      );
}
