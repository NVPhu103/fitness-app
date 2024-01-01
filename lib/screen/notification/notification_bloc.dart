import 'dart:convert';

import 'package:fitness_app/repository/notifications/models/notification_response.dart';
import 'package:fitness_app/repository/notifications/notifications_repository.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_state.dart';

class NotificationBloc extends Cubit<NotificationState> {
  final NotificationsRepository _notificationsRepository =
      NotificationsRepository();
  NotificationBloc() : super(const NotificationState());

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('USER_PROFILE');
    if (userJson != null) {
      final user = UserProfile.fromJson(json.decode(userJson));

      emit(state.copyWith(
        id: user.id,
      ));

      await onFetch(page: 1);
      _notificationsRepository.resetUnreadNotification(id: user.id);
    }
  }

  getDiary(String url) async {
    try {
      emit(state.copyWith(isTapDiary: false));
      final diary = await _notificationsRepository.getDiaryNotifications(
        url: url,
      );

      emit(state.copyWith(
        isTapDiary: true,
        diary: diary,
      ));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    } finally {
      emit(state.copyWith(isTapDiary: false));
    }
  }

  onFetch({
    required int page,
  }) async {
    try {
      if (page == 1) {
        emit(
          state.copyWith(
            canLoadMore: false,
          ),
        );
      }
      final data = await _notificationsRepository.filterNotifications(
        id: state.id,
        page: page,
      );

      var newDataList = List<NotificationResponse>.from(data.data ?? []);

      final maxLoadMore = ((data.totalPages ?? 0) / 10).floor();

      final canLoadMore = page <= maxLoadMore;

      emit(state.copyWith(
        dataList: newDataList,
        currentPage: page,
        canLoadMore: canLoadMore,
      ));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }
}
