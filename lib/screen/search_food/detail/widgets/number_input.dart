import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({
    super.key,
    this.hintText = 'Number',
    required this.onChanged,
    this.isClear,
    this.initValue,
  });

  final String hintText;
  final void Function(String) onChanged;
  final bool? isClear;
  final String? initValue;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initValue,
      onChanged: (value) {
        widget.onChanged(value);
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(
          minWidth: 0,
          maxHeight: 16.h,
        ),
        hintText: widget.hintText,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
