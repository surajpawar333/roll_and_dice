import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roll_dice_demo/src/utils/constants.dart';
import 'package:roll_dice_demo/src/utils/dialog_status.dart';
import 'package:roll_dice_demo/src/utils/firestore_service.dart';
import 'package:roll_dice_demo/src/utils/local_storage.dart';
import 'package:roll_dice_demo/src/utils/validation_model.dart';

import '../../../utils/extensions.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(LoginState(
          email: ValidationModel(null, null),
          password: ValidationModel(null, null),
          username: ValidationModel(null, null),
          confirmPassword: ValidationModel(null, null),
        )) {
    on<UsernameChanged>(_mapUsernameChangedEventToState);
    on<EmailChanged>(_mapEmailChangedEventToState);
    on<PasswordChanged>(_mapPasswordChangedEventToState);
    on<ConfirmPasswordChanged>(_mapConfirmPasswordChangedEventToState);
    on<ValidateForm>(_mapValidateFormEventToState);
    on<LoginSubmitted>(_mapLoginSubmittedEventToState);
    on<ToggleForm>(_mapToggleFormEventToState);
    on<SignUpFormSubmitted>(_mapSignUpFormSubmittedEventToState);
  }

  void _mapToggleFormEventToState(ToggleForm event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        isLogin: !state.isLogin,
        email: ValidationModel(null, null),
        password: ValidationModel(null, null),
        username: ValidationModel(null, null),
        confirmPassword: ValidationModel(null, null),
      ),
    );
  }

  void _mapUsernameChangedEventToState(UsernameChanged event, Emitter<LoginState> emit) {
    if (event.username.isValidName) {
      emit(state.copyWith(username: ValidationModel(event.username, null)));
    } else {
      emit(state.copyWith(username: ValidationModel(null, event.username == "" ? null : 'Please Enter a Valid Name')));
    }
    add(ValidateForm());
  }

  void _mapEmailChangedEventToState(EmailChanged event, Emitter<LoginState> emit) {
    if (event.email.isValidEmail) {
      emit(state.copyWith(email: ValidationModel(event.email, null)));
    } else {
      emit(state.copyWith(email: ValidationModel(null, event.email == "" ? null : 'Please Enter a Valid Email')));
    }
    add(ValidateForm());
  }

  void _mapPasswordChangedEventToState(PasswordChanged event, Emitter<LoginState> emit) {
    if (event.password.isValidPassword) {
      emit(state.copyWith(password: ValidationModel(event.password, null)));
    } else {
      emit(state.copyWith(
          password: ValidationModel(
              null,
              event.password == ""
                  ? null
                  : 'Password must contain an uppercase, lowercase, numeric digit and special character')));
    }
    add(ValidateForm());
  }

  void _mapConfirmPasswordChangedEventToState(ConfirmPasswordChanged event, Emitter<LoginState> emit) {
    if (event.password == state.password.value) {
      emit(state.copyWith(confirmPassword: ValidationModel(event.password, null)));
    } else {
      emit(state.copyWith(confirmPassword: ValidationModel(null, event.password == "" ? null : 'Password not match')));
    }
    add(ValidateForm());
  }

  void _mapValidateFormEventToState(ValidateForm event, Emitter<LoginState> emit) {
    if (state.isLogin && state.email.value != null && state.password.value != null) {
      emit(state.copyWith(isValidate: true));
    } else if (!state.isLogin &&
        state.email.value != null &&
        state.password.value != null &&
        state.username.value != null &&
        state.confirmPassword.value != null) {
      emit(state.copyWith(isValidate: true));
    } else {
      emit(state.copyWith(isValidate: false));
    }
  }

  _mapLoginSubmittedEventToState(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(dialogStatus: DialogStatus.loading, loadingMessage: 'Please Wait, Loading Details'));

    try {
      User? user = await FirebaseService().signIn(state.email.value!, state.password.value!);

      if (user != null) {
        LocalStorage().setUserData(id: user.uid, name: user.displayName ?? state.username.value!);
        DocumentSnapshot snapshot = await FirebaseService().getUserDetails(user.uid);
        if (snapshot.exists) {
          print('Document data: ${snapshot.data()}');
          if (snapshot.get(ConstantStrings.attemptRemaining) == 0) {
            throw ('You already completed number of attempts');
          }
          LocalStorage().setRollingData(
              attemptRemaining: snapshot.get(ConstantStrings.attemptRemaining),
              score: snapshot.get(ConstantStrings.score));
        } else {
          throw ('No records found for this data');
        }
      }

      emit(state.copyWith(dialogStatus: DialogStatus.loginSuccess));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(
            dialogStatus: DialogStatus.error, errorTitle: 'No User Found', errorBody: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(
            dialogStatus: DialogStatus.error,
            errorTitle: 'Incorrect Password',
            errorBody: 'Wrong password provided for that user.'));
      }
    } catch (e) {
      emit(state.copyWith(dialogStatus: DialogStatus.error, errorBody: e.toString()));
    }
  }

  _mapSignUpFormSubmittedEventToState(SignUpFormSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(dialogStatus: DialogStatus.loading, loadingMessage: 'Please Wait, Loading Details'));
    try {
      User? user = await FirebaseService().signUp(state.email.value!, state.password.value!);
      if (user != null) {
        await FirebaseService().addUser(user: user, username: state.username.value!, email: state.email.value!);
        emit(state.copyWith(dialogStatus: DialogStatus.signUpSuccess, isLogin: true));
      } else {
        emit(state.copyWith(
            dialogStatus: DialogStatus.error, errorTitle: 'No data found', errorBody: 'No users data found'));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(state.copyWith(
            dialogStatus: DialogStatus.error,
            errorTitle: 'Email Already Used',
            errorBody: 'The account already exists for that email.'));
      } else {
        emit(state.copyWith(dialogStatus: DialogStatus.error, errorTitle: e.code, errorBody: e.message));
      }
    } catch (e) {
      emit(state.copyWith(dialogStatus: DialogStatus.error, errorTitle: 'Error', errorBody: e.toString()));
    }
  }
}
