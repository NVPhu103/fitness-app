import 'dart:convert';

import 'package:fitness_app/repository/notifications/notifications_repository.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_state.dart';

class DashboardBloc extends Cubit<DashboardState> {
  final NotificationsRepository _notificationsRepository =
      NotificationsRepository();
  DashboardBloc() : super(const DashboardState());

  getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('USER_PROFILE');
      if (userJson != null) {
        final user = UserProfile.fromJson(json.decode(userJson));
        final data = await _notificationsRepository.getUnreadNotification(
          id: user.id,
        );

        emit(state.copyWith(
          numNoti: data.unreadNotification,
        ));
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }

  onReset() {
    emit(state.copyWith(
      numNoti: 0,
    ));
  }
}
