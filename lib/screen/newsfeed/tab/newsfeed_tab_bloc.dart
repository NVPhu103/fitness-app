import 'dart:convert';

import 'package:fitness_app/repository/newsfeed/models/location_response.dart';
import 'package:fitness_app/repository/newsfeed/models/newsfeed_response/newsfeed_response.dart';
import 'package:fitness_app/repository/newsfeed/newsfeed_repository.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'newsfeed_tab_state.dart';

class NewsfeedTabBloc extends Cubit<NewsfeedTabState> {
  final NewsfeedRepository _newsfeedTabRepository = NewsfeedRepository();
  NewsfeedTabBloc({
    required int currentTab,
  }) : super(NewsfeedTabState(currentTab: currentTab));

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('USER_PROFILE');
    if (userJson != null) {
      final user = UserProfile.fromJson(json.decode(userJson));

      emit(state.copyWith(
        id: user.id,
      ));

      await onFetch(page: 1);
    }
  }

  onChangeExerciseName(String exerciseName) {
    emit(
      state.copyWith(
        exerciseName: exerciseName,
      ),
    );
  }

  onChangeLocation(LocationResponse? location) {
    emit(
      state.copyWith(
        location: location,
      ),
    );
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
      final data = await _newsfeedTabRepository.filterNewsfeed(
        createdBy: state.currentTab == 1 ? state.id : null,
        exerciseName:
            (state.exerciseName ?? '').isNotEmpty ? state.exerciseName : null,
        locationId: state.location?.id,
        page: page,
      );

      var newDataList = List<NewsfeedResponse>.from(data.data ?? []);

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
