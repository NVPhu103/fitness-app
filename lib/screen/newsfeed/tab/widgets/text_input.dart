import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.maxLines,
    this.readOnly = false,
    this.initialValue,
  });

  final String hintText;
  final void Function(String) onChanged;
  final int? maxLines;
  final bool readOnly;
  final String? initialValue;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      enabled: !widget.readOnly,
      onChanged: (value) {
        widget.onChanged(value);
      },
      maxLines: widget.maxLines ?? 1,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
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
