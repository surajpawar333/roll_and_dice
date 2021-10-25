import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roll_dice_demo/src/utils/constants.dart';
import 'package:roll_dice_demo/src/utils/dialog_status.dart';
import 'package:roll_dice_demo/src/utils/firestore_service.dart';

import '../model/user.dart' as model;

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc() : super(LeaderboardState()) {
    on<LoadInitialLeaderboard>(_mapLoadInitialLeaderboardEventToState);
  }

  _mapLoadInitialLeaderboardEventToState(LoadInitialLeaderboard event, Emitter<LeaderboardState> emit) async {
    emit(state.copyWith(dialogStatus: DialogStatus.loading, loadingMessage: 'Please Wait, Loading Details'));
    try {
      QuerySnapshot<Object?> querySnapshot = await FirebaseService().getLeaderboard();
      List<model.User> userList = [];
      querySnapshot.docs.forEach((element) {
        userList.add(
            model.User(userName: element.get(ConstantStrings.userName), score: element.get(ConstantStrings.score)));
      });
      emit(state.copyWith(dialogStatus: DialogStatus.success, userList: userList));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(dialogStatus: DialogStatus.error, errorTitle: e.code, errorBody: e.message));
    } catch (e) {
      emit(state.copyWith(dialogStatus: DialogStatus.error, errorTitle: 'Error', errorBody: e.toString()));
    }
  }
}
