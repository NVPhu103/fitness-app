import 'package:fitness_app/components/button/solid_button.dart';
import 'package:fitness_app/components/popup/popup.dart';
import 'package:fitness_app/utilities/spaces.dart';
import 'package:flutter/material.dart';

import 'number_input.dart';

class PopupInputNumBerServings extends StatefulWidget {
  const PopupInputNumBerServings._({
    required this.initValue,
  });

  final String initValue;

  static Future<String?> show(
    BuildContext context, {
    required String initValue,
  }) {
    return showAppModalBottomSheetV3<String>(
      context: context,
      child: PopupInputNumBerServings._(initValue: initValue),
    );
  }

  @override
  State<PopupInputNumBerServings> createState() =>
      _PopupInputNumBerServingsState();
}

class _PopupInputNumBerServingsState extends State<PopupInputNumBerServings> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return TitleBottomSheetAutoHeightWrapper(
      title: 'Change Number of Servings',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberInput(
              initValue: widget.initValue,
              hintText: 'Number',
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              isClear: true,
            ),
            spaceH36,
            SizedBox(
              width: double.infinity,
              child: AppSolidButton.medium(
                onPressed: text.isNotEmpty
                    ? () {
                        double? value = double.tryParse(text);
                        if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
                          Navigator.of(context).pop<String>(null);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Malformed",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 1),
                          ));
                        } else if (value != null && value <= 0) {
                          Navigator.of(context).pop<String>(null);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "The number that must be entered is greater than 0",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 1),
                          ));
                        } else {
                          Navigator.of(context).pop<String>(text);
                        }
                      }
                    : null,
                'Submit',
              ),
            ),
            spaceH20,
          ],
        ),
      ),
    );
  }
}
