import 'package:fitness_app/components/popup/popup.dart';
import 'package:fitness_app/screen/newsfeed/tab/create/create_newsfeed_screen.dart';
import 'package:fitness_app/utilities/spaces.dart';
import 'package:flutter/material.dart';

class SelectOptionCreatePopup extends StatefulWidget {
  const SelectOptionCreatePopup._({
    required this.onReload,
  });

  final VoidCallback onReload;

  static Future<void> show(BuildContext context,
      {required VoidCallback onReload}) {
    return showAppModalBottomSheetV3<void>(
      context: context,
      child: SelectOptionCreatePopup._(onReload: onReload),
    );
  }

  @override
  State<SelectOptionCreatePopup> createState() =>
      _SelectOptionCreatePopupState();
}

class _SelectOptionCreatePopupState extends State<SelectOptionCreatePopup> {
  @override
  Widget build(BuildContext context) {
    return TitleBottomSheetAutoHeightWrapper(
      title: 'Select option',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNewsfeedScreen(
                              type: 0,
                              onReload: widget.onReload,
                            )));
              },
              child: const Text(
                'Share your thoughts',
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNewsfeedScreen(
                              type: 1,
                              onReload: widget.onReload,
                            )));
              },
              child: const Text(
                'Plan to do something',
              ),
            ),
            spaceH20,
          ],
        ),
      ),
    );
  }
}
