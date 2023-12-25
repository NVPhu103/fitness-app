import 'package:fitness_app/repository/notifications/notifications_repository.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'suggesstion_state.dart';

class SuggesstionBloc extends Cubit<SuggesstionState> {
  final NotificationsRepository _notificationsRepository =
      NotificationsRepository();
  SuggesstionBloc() : super(const SuggesstionState());

  getData(String url) async {
    try {
      emit(state.copyWith(isLoading: true));
      final dataList =
          await _notificationsRepository.getSuggesstionNotifications(
        url: url,
      );

      emit(state.copyWith(
        isLoading: false,
        dataList: dataList,
      ));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }
}
