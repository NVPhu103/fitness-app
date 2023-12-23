import 'dart:convert';

import 'package:fitness_app/repository/nutritions/nutritions_repository.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:fitness_app/utilities/date_time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_diary_state.dart';

class DetailDiaryBloc extends Cubit<DetailDiaryState> {
  final NutritionsRepository _nutritionsRepository = NutritionsRepository();
  DetailDiaryBloc() : super(const DetailDiaryState());

  getData() async {
    try {
      emit(state.copyWith(isLoading: true));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('USER_PROFILE');
      if (userJson != null) {
        final user = UserProfile.fromJson(json.decode(userJson));
        final data = await _nutritionsRepository.getDailynutritionById(
          id: user.id,
        );

        emit(state.copyWith(
          data: data,
          currentTime: DateTime.now().toDay,
          startDate: DateTime.now().toDay,
          userId: user.userId,
        ));
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  onChangeType(int type) {
    if (type == 0) {
      emit(state.copyWith(
        type: type,
        startDate: state.currentTime,
        timeDisplay: _convertText(
          state.currentTime,
          null,
          type,
        ),
      ));
    } else {
      emit(state.copyWith(
        type: type,
        startDate: state.currentTime?.subtract(
          const Duration(days: 7),
        ),
        endDate: state.currentTime,
        timeDisplay: _convertText(
          state.currentTime?.subtract(
            const Duration(days: 7),
          ),
          state.currentTime,
          type,
        ),
      ));
    }
  }

  onNext() {
    if (state.type == 0) {
      emit(
        state.copyWith(
          startDate: state.startDate?.add(
            const Duration(days: 1),
          ),
          endDate: null,
          timeDisplay: _convertText(
            state.startDate?.add(
              const Duration(days: 1),
            ),
            null,
            0,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          startDate: state.endDate,
          endDate: state.endDate?.add(
            const Duration(days: 7),
          ),
          timeDisplay: _convertText(
            state.endDate,
            state.endDate?.add(
              const Duration(days: 7),
            ),
            1,
          ),
        ),
      );
    }
  }

  onBack() {
    if (state.type == 0) {
      emit(
        state.copyWith(
          startDate: state.startDate?.subtract(
            const Duration(days: 1),
          ),
          endDate: null,
          timeDisplay: _convertText(
            state.startDate?.subtract(
              const Duration(days: 1),
            ),
            null,
            0,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          startDate: state.startDate?.subtract(
            const Duration(days: 7),
          ),
          endDate: state.startDate,
          timeDisplay: _convertText(
            state.startDate?.subtract(
              const Duration(days: 7),
            ),
            state.startDate,
            1,
          ),
        ),
      );
    }
  }

  onFetch() async {
    try {
      final dataTotal = await _nutritionsRepository.getDailynutritionTotalById(
        id: state.userId,
        startDate: state.startDate ?? DateTime.now().toDay,
        endDate: state.endDate,
        type: _convertType(state.type),
      );

      emit(state.copyWith(
        dataTotal: dataTotal,
      ));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }

  String _convertType(int type) {
    if (type == 0) {
      return 'DAY';
    }
    return 'WEEK';
  }

  String _convertText(DateTime? startDate, DateTime? endDate, int type) {
    if (type == 0) {
      return startDate == state.currentTime
          ? 'Today'
          : '${startDate?.format(pattern: yyyy_mm_dd)}';
    }
    return '${startDate?.format(pattern: yyyy_mm_dd)} to ${endDate?.format(pattern: yyyy_mm_dd)}';
  }
}
