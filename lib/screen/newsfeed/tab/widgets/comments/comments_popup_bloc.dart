import 'dart:convert';

import 'package:fitness_app/api/services/newsfeed/models/create_comment_request.dart';
import 'package:fitness_app/repository/newsfeed/models/comment_response/comment_response.dart';
import 'package:fitness_app/repository/newsfeed/newsfeed_repository.dart';
import 'package:fitness_app/screen/user_profile/components/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'comments_popup_state.dart';

class CommentsPopupBloc extends Cubit<CommentsPopupState> {
  final NewsfeedRepository _newsfeedRepository = NewsfeedRepository();
  CommentsPopupBloc() : super(const CommentsPopupState());

  getData(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('USER_PROFILE');
      if (userJson != null) {
        final user = UserProfile.fromJson(json.decode(userJson));

        emit(state.copyWith(
          id: id,
          userId: user.id,
        ));

        await onFetch(page: 1);
      }
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    } finally {
      emit(state.copyWith(isLoading: false));
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
      final data = await _newsfeedRepository.filterComments(
        id: state.id,
        page: page,
      );

      var newDataList = List<CommentResponse>.from(data.data ?? []);

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

  onSendComment({
    required String comment,
  }) async {
    emit(
      state.copyWith(onReload: false),
    );
    try {
      await _newsfeedRepository.createComment(
          request: CreateCommentRequest(
        newsfeedId: state.id,
        createdBy: state.userId,
        content: comment,
      ));
      emit(
        state.copyWith(onReload: true),
      );
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    } finally {
      emit(
        state.copyWith(onReload: false),
      );
    }
  }

  onDeleteComment(String idCom) async {
    emit(
      state.copyWith(onReload: false),
    );
    try {
      await _newsfeedRepository.deleteComment(
        id: state.userId,
        idCom: idCom,
      );
      emit(
        state.copyWith(onReload: true),
      );
    } catch (error, statckTrace) {
      if (kDebugMode) {
        print("$error + $statckTrace");
      }
    } finally {
      emit(
        state.copyWith(onReload: false),
      );
    }
  }
}
