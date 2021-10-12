// Copyright (c) 2021, Kato Shinya. All rights reserved.
// Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:duo_tracker/src/security/text_mask.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    Key? key,
    this.label,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.prefixIcon,
    this.maskText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final void Function(String text)? onChanged;
  final void Function(String text)? onSubmitted;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? label;
  final bool maskText;
  final int? maxLength;
  final int? maxLines;
  final Icon? prefixIcon;

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (widget.maskText) {
      if (!_focusNode.hasFocus) {
        super.setState(() {
          widget.controller.text = TextMask.apply(text: widget.controller.text);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          if (widget.label != null)
            const SizedBox(
              height: 10,
            ),
          TextField(
            maxLength: widget.maxLength,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: widget.controller.text,
              ),
            ),
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              counterText: widget.maxLength != null
                  ? '${widget.maxLength! - widget.controller.text.length} / ${widget.maxLength}'
                  : '',
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            onChanged: widget.onChanged,
            onSubmitted: (final text) {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!.call(text);
              }

              if (widget.maskText) {
                super.setState(() {
                  widget.controller.text = TextMask.apply(text: text);
                });
              } else {
                widget.controller.text = text;
              }
            },
            focusNode: _focusNode,
          )
        ],
      );
}
