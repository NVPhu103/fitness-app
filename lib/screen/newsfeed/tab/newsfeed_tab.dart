import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/components/search_input.dart';
import 'package:fitness_app/repository/newsfeed/models/newsfeed_response/newsfeed_response.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:fitness_app/utilities/date_time.dart';
import 'package:fitness_app/utilities/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'location/search_location_screen.dart';
import 'newsfeed_tab_bloc.dart';
import 'newsfeed_tab_state.dart';
import 'widgets/comments/comments_popup.dart';
import 'widgets/select_option_create_popup.dart';

class NewsfeedTab extends StatefulWidget {
  const NewsfeedTab({super.key});

  @override
  State<NewsfeedTab> createState() => _NewsfeedTabState();
}

class _NewsfeedTabState extends State<NewsfeedTab> {
  late NewsfeedTabBloc bloc;

  final PagingController<int, NewsfeedResponse> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);

  @override
  void initState() {
    super.initState();
    bloc = context.read<NewsfeedTabBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      if (pageKey != 1) {
        bloc.onFetch(page: pageKey);
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<NewsfeedTabBloc, NewsfeedTabState>(
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
          BlocListener<NewsfeedTabBloc, NewsfeedTabState>(
            listenWhen: (previous, current) =>
                previous.exerciseName != current.exerciseName ||
                previous.location != current.location,
            listener: (context, state) {
              bloc.onFetch(page: 1);
            },
          ),
        ],
        child: BlocBuilder<NewsfeedTabBloc, NewsfeedTabState>(
          builder: (context, state) {
            return Scaffold(
              floatingActionButton:
                  state.dataList == null || state.currentTab == 0
                      ? null
                      : FloatingActionButton(
                          onPressed: () {
                            SelectOptionCreatePopup.show(
                              context,
                              onReload: () {
                                Navigator.pop(context);
                                bloc.onFetch(page: 1);
                              },
                            );
                          },
                          backgroundColor: context.appColor.colorBlue,
                          child: const Icon(
                            Icons.add,
                          ),
                        ),
              body: Column(
                children: [
                  if (state.currentTab == 0) ...[
                    SearchInput(
                      hintText: 'Exercise Name',
                      onChanged: (keyword) {
                        bloc.onChangeExerciseName(keyword);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchLocationScreen(
                                            onChange: (p0) {
                                              bloc.onChangeLocation(p0);
                                            },
                                          )));
                            },
                            child: SearchInput(
                              key: ObjectKey(state.location),
                              readOnly: true,
                              hintText: 'Location',
                              initialValue: state.location?.location,
                            ),
                          ),
                        ),
                        spaceW8,
                        InkWell(
                          onTap: () {
                            bloc.onChangeLocation(null);
                          },
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              color: context.appColor.colorRed,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: context.appColor.colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  state.dataList == null
                      ? Column(
                          children: [
                            spaceH40,
                            const Loading(),
                          ],
                        )
                      : (state.dataList ?? []).isEmpty
                          ? _empty(context)
                          : Expanded(
                              child: PagedListView.separated(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                pagingController: _pagingController,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  top: 16,
                                  bottom: 72,
                                ),
                                physics: const ClampingScrollPhysics(),
                                builderDelegate:
                                    PagedChildBuilderDelegate<NewsfeedResponse>(
                                  noItemsFoundIndicatorBuilder: _empty,
                                  itemBuilder: (context, item, index) {
                                    return _item(
                                      context,
                                      item,
                                      index,
                                    );
                                  },
                                ),
                                separatorBuilder: (context, index) => spaceH12,
                              ),
                            ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return const Empty();
  }

  Widget _item(
    BuildContext context,
    NewsfeedResponse data,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.appColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.appColor.colorGrey,
                      ),
                      child: Image.asset(
                        "assets/images/human.png",
                        height: 20.r,
                        width: 20.r,
                      ),
                    ),
                    spaceW4,
                    Text(
                      data.userProfileName ?? '',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (data.exerciseName != null) ...[
                      Text(
                        ' đang định ${data.exerciseName}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              spaceW4,
              Text(
                data.createdTime
                        ?.add(
                          const Duration(hours: 7),
                        )
                        .getDiffFromToday() ??
                    '',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
          if (data.content != null) ...[
            spaceH8,
            Text(
              data.content ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (data.exerciseTime != null) ...[
            spaceH8,
            Row(
              children: [
                const Icon(Icons.timer_outlined),
                spaceW4,
                Text(
                  data.exerciseTime?.format(pattern: yyyy_mm_dd_HH_mm) ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (data.location != null) ...[
            spaceH8,
            Row(
              children: [
                const Icon(Icons.location_on),
                spaceW4,
                Text(
                  data.location?.location ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          spaceH12,
          InkWell(
            onTap: () {
              CommentsPopup.show(
                context,
                id: data.id ?? '',
                onReload: () {
                  //
                },
              );
            },
            child: const Icon(
              Icons.comment_outlined,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
