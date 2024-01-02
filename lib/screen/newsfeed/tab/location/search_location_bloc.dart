import 'package:fitness_app/repository/newsfeed/newsfeed_repository.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_location_state.dart';

class SearchLocationBloc extends Cubit<SearchLocationState> {
  final NewsfeedRepository _newsfeedTabRepository = NewsfeedRepository();
  SearchLocationBloc() : super(const SearchLocationState());

  getData() async {
    emit(state.copyWith(
      isLoading: true,
    ));
    await onFetch('');
    emit(state.copyWith(
      isLoading: false,
    ));
  }

  onFetch(
    String location,
  ) async {
    try {
      final data = await _newsfeedTabRepository.searchLocation(
        location: location,
      );

      emit(state.copyWith(
        dataList: data,
      ));
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    }
  }
}
