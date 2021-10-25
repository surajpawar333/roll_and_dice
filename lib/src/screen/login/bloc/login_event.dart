part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class UsernameChanged extends LoginEvent {
  const UsernameChanged(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
}

class EmailChanged extends LoginEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends LoginEvent {
  const ConfirmPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class ToggleForm extends LoginEvent {
  const ToggleForm();
}

class SignUpFormSubmitted extends LoginEvent {
  const SignUpFormSubmitted();
}

class ValidateForm extends LoginEvent {
  const ValidateForm();
}

class DialogStatusChanged extends LoginEvent {
  const DialogStatusChanged(this.status);

  final DialogStatus status;

  @override
  List<Object> get props => [status];
}
