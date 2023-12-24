import 'package:fitness_app/components/loading.dart';
import 'package:fitness_app/repository/notifications/models/notification_response.dart';
import 'package:fitness_app/screen/diary/components/diary.dart';
import 'package:fitness_app/screen/diary/diary_screen.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:fitness_app/utilities/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'notification_bloc.dart';
import 'notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
    required this.name,
    required this.diary,
    required this.userProfile,
  });

  final String name;
  final Diary diary;
  final UserProfile userProfile;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationBloc bloc;

  final PagingController<int, NotificationResponse> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);

  @override
  void initState() {
    super.initState();
    bloc = NotificationBloc()..getData();
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
          BlocListener<NotificationBloc, NotificationState>(
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
        ],
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Select Food'),
              ),
              body: state.dataList == null
                  ? const Loading()
                  : PagedListView.separated(
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
                          PagedChildBuilderDelegate<NotificationResponse>(
                        noItemsFoundIndicatorBuilder: _empty,
                        itemBuilder: (context, item, index) {
                          return _item(
                            context,
                            item,
                            index,
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => const Divider(),
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
    NotificationResponse data,
    int index,
  ) {
    return InkWell(
      onTap: () async {
        if (data.page == 'DIARY') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiaryScreen(
                name: widget.name,
                diary: widget.diary,
                userProfile: widget.userProfile,
                urlNoti: data.url,
              ),
            ),
          );
        } else {
          //
        }
      },
      child: ListTile(
        leading: CircleAvatar(
            child: Icon(
          Icons.notifications,
          color: context.appColor.colorWhite,
          size: 20,
        )),
        title: Text(data.title ?? ''),
        subtitle: Text(data.content ?? ''),
      ),
    );
  }
}
