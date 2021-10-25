part of 'login_bloc.dart';

class LoginState extends Equatable {
  final ValidationModel email;
  final ValidationModel password;
  final ValidationModel username;
  final ValidationModel confirmPassword;
  final bool isLogin;
  final DialogStatus dialogStatus;
  final String loadingMessage;
  final String errorTitle;
  final String errorBody;
  final bool isValidate;

  LoginState({
    required this.email,
    required this.password,
    required this.username,
    required this.confirmPassword,
    this.isLogin = true,
    this.dialogStatus = DialogStatus.unknown,
    this.loadingMessage = "",
    this.errorBody = "",
    this.errorTitle = "",
    this.isValidate = false,
  });

  LoginState copyWith({
    ValidationModel? email,
    ValidationModel? password,
    ValidationModel? username,
    ValidationModel? confirmPassword,
    bool? isLogin,
    DialogStatus? dialogStatus,
    String? loadingMessage,
    String? errorTitle,
    String? errorBody,
    bool? isValidate,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLogin: isLogin ?? this.isLogin,
      dialogStatus: dialogStatus ?? this.dialogStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      errorTitle: errorTitle ?? this.errorTitle,
      errorBody: errorBody ?? this.errorBody,
      isValidate: isValidate ?? this.isValidate,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        username,
        confirmPassword,
        isLogin,
        dialogStatus,
        loadingMessage,
        errorBody,
        errorTitle,
        isValidate
      ];
}
