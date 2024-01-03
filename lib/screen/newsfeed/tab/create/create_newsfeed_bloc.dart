import 'dart:convert';

import 'package:fitness_app/api/services/newsfeed/models/create_newsfeed_request.dart';
import 'package:fitness_app/repository/newsfeed/models/location_response.dart';
import 'package:fitness_app/repository/newsfeed/newsfeed_repository.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_newsfeed_state.dart';

class CreateNewsfeedBloc extends Cubit<CreateNewsfeedState> {
  final NewsfeedRepository _newsfeedRepository = NewsfeedRepository();
  CreateNewsfeedBloc() : super(const CreateNewsfeedState());

  getData(int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('USER_PROFILE');
    if (userJson != null) {
      final user = UserProfile.fromJson(json.decode(userJson));

      emit(state.copyWith(
        id: user.id,
        type: type,
      ));
    }
  }

  onChangeExerciseName(String exerciseName) {
    emit(
      state.copyWith(
        exerciseName: exerciseName,
      ),
    );
  }

  onChangeContent(String content) {
    emit(
      state.copyWith(
        content: content,
      ),
    );
  }

  onChangeExerciseTime(DateTime? exerciseTime) {
    emit(
      state.copyWith(
        exerciseTime: exerciseTime,
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

  onCreate() async {
    emit(state.copyWith(isSubmitSuccess: false));
    try {
      await _newsfeedRepository.createNewsfeed(
        request: CreateNewsfeedRequest(
          exerciseTime: state.exerciseTime,
          exerciseName: state.exerciseName,
          locationId: state.location?.id,
          content: state.content,
          createdBy: state.id,
        ),
      );

      emit(state.copyWith(isSubmitSuccess: true));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    } finally {
      emit(state.copyWith(isSubmitSuccess: false));
    }
  }
}
