import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roll_dice_demo/src/utils/constants.dart';
import 'package:roll_dice_demo/src/utils/dialog_status.dart';
import 'package:roll_dice_demo/src/utils/firestore_service.dart';
import 'package:roll_dice_demo/src/utils/local_storage.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageState()) {
    on<DiceRolled>(_mapDiceRolledEventToState);
    on<HomePageInitial>(_mapHomePageInitialEventToState);
    on<LogOut>(_mapLogOutEventToState);
  }

  void _mapLogOutEventToState(LogOut event, Emitter<HomePageState> emit) async {
    await LocalStorage().clearPreferences();

    emit(state.copyWith(dialogStatus: DialogStatus.logout));
  }

  _mapHomePageInitialEventToState(HomePageInitial event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(
      userId: LocalStorage().getString(ConstantStrings.userId),
      username: LocalStorage().getString(ConstantStrings.userName),
      attemptRemaining: LocalStorage().getInt(ConstantStrings.attemptRemaining) ?? 10,
      score: LocalStorage().getInt(ConstantStrings.score) ?? 0,
    ));
  }

  _mapDiceRolledEventToState(DiceRolled event, Emitter<HomePageState> emit) async {
    int randomNumber = Random().nextInt(6) + 1;
    int numberOfAttemptLeft = state.attemptRemaining - 1;
    int score = state.score + randomNumber;
    bool isLast = state.attemptRemaining - 1 == 0;

    if (isLast)
      emit(state.copyWith(dialogStatus: DialogStatus.loading, loadingMessage: 'Please Wait, Loading Details'));
    try {
      LocalStorage().setRollingData(attemptRemaining: numberOfAttemptLeft, score: score);
      await FirebaseService().updateUser(userId: state.userId, attemptRemaining: numberOfAttemptLeft, score: score);
      emit(state.copyWith(
          dialogStatus: isLast ? DialogStatus.success : DialogStatus.unknown,
          attemptRemaining: numberOfAttemptLeft,
          score: score,
          currentAttemptPoint: randomNumber));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(dialogStatus: DialogStatus.error, errorTitle: e.code, errorBody: e.message));
    } catch (e) {
      emit(state.copyWith(dialogStatus: DialogStatus.error, errorTitle: 'Error', errorBody: e.toString()));
    }
  }
}
