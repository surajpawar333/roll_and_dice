part of 'home_page_bloc.dart';

class HomePageState extends Equatable {
  final DialogStatus dialogStatus;
  final String loadingMessage;
  final String errorTitle;
  final String errorBody;
  final int score;
  final int attemptRemaining;
  final int currentAttemptPoint;
  final String username;
  final String userId;

  const HomePageState({
    this.dialogStatus = DialogStatus.unknown,
    this.loadingMessage = "",
    this.errorBody = "",
    this.errorTitle = "",
    this.attemptRemaining = 10,
    this.score = 0,
    this.currentAttemptPoint = 0,
    this.username = "",
    this.userId = "",
  });

  HomePageState copyWith({
    DialogStatus? dialogStatus,
    String? loadingMessage,
    String? errorTitle,
    String? errorBody,
    int? attemptRemaining,
    int? score,
    int? currentAttemptPoint,
    String? username,
    String? userId,
  }) {
    return HomePageState(
      dialogStatus: dialogStatus ?? this.dialogStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      errorTitle: errorTitle ?? this.errorTitle,
      errorBody: errorBody ?? this.errorBody,
      attemptRemaining: attemptRemaining ?? this.attemptRemaining,
      score: score ?? this.score,
      currentAttemptPoint: currentAttemptPoint ?? this.currentAttemptPoint,
      username: username ?? this.username,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props =>
      [dialogStatus, loadingMessage, errorBody, errorTitle, attemptRemaining, score, currentAttemptPoint];
}
