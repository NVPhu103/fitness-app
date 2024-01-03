import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/components/popup/popup.dart';
import 'package:fitness_app/repository/newsfeed/models/comment_response/comment_response.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:fitness_app/utilities/date_time.dart';
import 'package:fitness_app/utilities/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'comments_popup_bloc.dart';
import 'comments_popup_state.dart';

class CommentsPopup extends StatefulWidget {
  const CommentsPopup({
    super.key,
    required this.id,
    required this.onReload,
  });

  final String id;
  final VoidCallback onReload;

  static Future<void> show(
    BuildContext context, {
    required String id,
    required VoidCallback onReload,
  }) {
    return showAppModalBottomSheetV3<void>(
      context: context,
      child: CommentsPopup(
        id: id,
        onReload: onReload,
      ),
    );
  }

  @override
  State<CommentsPopup> createState() => _CommentsPopupState();
}

class _CommentsPopupState extends State<CommentsPopup> {
  late CommentsPopupBloc bloc;
  late TextEditingController smsTextCtrl;

  late FocusNode _focusNode;

  final PagingController<int, CommentResponse> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 5);

  @override
  void initState() {
    super.initState();
    bloc = CommentsPopupBloc()..getData(widget.id);
    smsTextCtrl = TextEditingController();
    _focusNode = FocusNode();
    _pagingController.addPageRequestListener((pageKey) {
      if (pageKey != 1 && mounted) {
        bloc.onFetch(page: pageKey);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    smsTextCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<CommentsPopupBloc, CommentsPopupState>(
            listenWhen: (previous, current) =>
                previous.dataList != current.dataList,
            listener: (context, state) {
              if (state.currentPage == 1) {
                _pagingController.refresh();
              }
              if (state.canLoadMore) {
                _pagingController.appendPage(
                  state.dataList ?? [],
                  state.currentPage + 1,
                );
              } else {
                _pagingController.appendLastPage(state.dataList ?? []);
              }
            },
          ),
          BlocListener<CommentsPopupBloc, CommentsPopupState>(
            listenWhen: (previous, current) =>
                previous.onReload != current.onReload && current.onReload,
            listener: (context, state) {
              bloc.onFetch(page: 1);
            },
          ),
        ],
        child: BlocBuilder<CommentsPopupBloc, CommentsPopupState>(
          builder: (context, state) {
            return TitleBottomSheetAutoHeightWrapper(
              title: 'Bình luận',
              minimum: EdgeInsets.only(bottom: 8.h),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: SizedBox(
                  height: 1.sh * 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: state.isLoading
                            ? const Loading()
                            : (state.dataList ?? []).isEmpty
                                ? _empty(context)
                                : PagedListView.separated(
                                    addAutomaticKeepAlives: true,
                                    cacheExtent: 99999,
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(bottom: 72.h),
                                    builderDelegate: PagedChildBuilderDelegate<
                                        CommentResponse>(
                                      itemBuilder: (context, item, index) {
                                        return _item(context, data: item);
                                      },
                                    ),
                                    separatorBuilder: (context, index) =>
                                        spaceH20,
                                    pagingController: _pagingController,
                                  ),
                      ),
                      _sendComment(context),
                      spaceH8,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Text(
        'Empty',
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required CommentResponse data,
  }) {
    final timeText = data.createdTime
            ?.add(
              const Duration(hours: 7),
            )
            .getDiffFromToday() ??
        '';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.appColor.colorGrey,
                      ),
                      child: Image.asset(
                        "assets/images/human.png",
                        height: 12.r,
                        width: 12.r,
                      ),
                    ),
                    spaceW4,
                    Text(
                      data.userProfileName ?? '',
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
                spaceH4,
                Text(
                  data.content ?? '',
                  style: context.textTheme.bodySmall,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                spaceH6,
                Text(
                  timeText ?? '',
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
            if (data.createdBy == bloc.state.userId)
              InkWell(
                onTap: () {
                  bloc.onDeleteComment(data.id ?? '');
                },
                child: Icon(
                  Icons.close,
                  color: context.appColor.colorRed,
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _sendComment(BuildContext context) {
    return Column(
      children: [
        spaceH12,
        Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 3,
                controller: smsTextCtrl,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: context.appColor.colorWhite,
                  focusColor: context.appColor.colorWhite,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.appColor.colorGrey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(28.r)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.appColor.colorGrey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(28.r)),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      bloc.onSendComment(
                        comment: smsTextCtrl.text,
                      );
                      smsTextCtrl.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.send,
                        color: context.appColor.colorBlue,
                      ),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  hintText: "Comment",
                  hintStyle: context.textTheme.bodySmall?.copyWith(
                    color: context.appColor.colorGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
