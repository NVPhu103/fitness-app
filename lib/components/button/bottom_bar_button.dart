import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    super.key,
    required this.button1,
    this.button2,
    this.widgetOnButton,
  });

  final Widget button1;
  final Widget? button2;
  final Widget? widgetOnButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.appColor.colorWhite,
      ),
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widgetOnButton != null) ...[
              widgetOnButton!,
            ],
            Row(
              children: [
                Expanded(
                  child: button1,
                ),
                if (button2 != null) ...[
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: button2!,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
