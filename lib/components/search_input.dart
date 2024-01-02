import 'dart:async';

import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    this.controller,
    this.readOnly = false,
    this.focusNode,
    this.onChanged,
    this.hintText = '',
    this.initialValue,
  });

  final TextEditingController? controller;
  final void Function(String text)? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final String? hintText;
  final String? initialValue;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late Timer _debounce;

  void _onChangeText(String text) {
    if (_debounce.isActive) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      if (widget.onChanged != null) {
        widget.onChanged!(text);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _debounce = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: TextFormField(
        initialValue: widget.initialValue,
        focusNode: widget.focusNode,
        onChanged: _onChangeText,
        readOnly: widget.readOnly,
        enabled: !widget.readOnly,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          fillColor: context.appColor.colorWhite,
          focusColor: context.appColor.colorWhite,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.appColor.colorWhite,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          hintText: widget.hintText,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.appColor.colorBlack.withOpacity(0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.appColor.colorWhite,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
        ),
      ),
    );
  }
}
