import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget _wrapper(BuildContext context, {required Widget child}) => Container(
      decoration: BoxDecoration(
        color: context.appColor.colorWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      width: double.infinity,
      child: child,
    );

class TitleBottomSheetAutoHeightWrapper extends StatelessWidget {
  const TitleBottomSheetAutoHeightWrapper({
    super.key,
    required this.child,
    this.title,
    this.subTitle,
    this.subTitleWidget,
    this.onCloseTapped,
    this.minChildSize = 0.4,
    this.initialChildSize = 0.8,
    this.maxChildSize = 0.95,
    this.isHiddenTitleBar = false,
    this.closeBtn,
    this.minimum = const EdgeInsets.only(bottom: 16),
    this.titlePadding,
  });

  final VoidCallback? onCloseTapped;
  final String? title;
  final String? subTitle;
  final Widget? subTitleWidget;
  final Widget child;
  final double minChildSize;
  final double initialChildSize;
  final double maxChildSize;
  final bool isHiddenTitleBar;
  final Widget? closeBtn;
  final EdgeInsets? minimum;
  final double? titlePadding;
  @override
  Widget build(BuildContext context) {
    return _wrapper(
      context,
      child: SafeArea(
        minimum: minimum ?? const EdgeInsets.only(bottom: 16),
        child: Flex(
          mainAxisSize: MainAxisSize.min,
          direction: Axis.vertical,
          children: [
            Visibility(
              visible: !isHiddenTitleBar,
              child: RPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: titlePadding ?? 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? '',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          subTitle != null
                              ? Text(
                                  subTitle ?? '',
                                  style: context.textTheme.labelMedium,
                                )
                              : const SizedBox(),
                          if (subTitleWidget != null) subTitleWidget!
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (onCloseTapped == null) {
                          Navigator.pop(context);
                        } else {
                          onCloseTapped!();
                        }
                      },
                      child: Container(
                        child: closeBtn ??
                            Container(
                              alignment: Alignment.centerRight,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.close),
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

Future<T?> showAppModalBottomSheetV3<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  BoxConstraints? boxConstraints,
}) {
  return showModalBottomSheet<T?>(
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    constraints: boxConstraints ??
        BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top,
        ),
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: child,
      );
    },
  );
}
