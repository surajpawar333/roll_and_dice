part of 'leaderboard_bloc.dart';

class LeaderboardState extends Equatable {
  final DialogStatus dialogStatus;
  final String loadingMessage;
  final String errorTitle;
  final String errorBody;
  final List<model.User> userList;

  const LeaderboardState({
    this.dialogStatus = DialogStatus.unknown,
    this.loadingMessage = "",
    this.errorBody = "",
    this.errorTitle = "",
    this.userList = const [],
  });

  LeaderboardState copyWith({
    DialogStatus? dialogStatus,
    String? loadingMessage,
    String? errorTitle,
    String? errorBody,
    List<model.User>? userList,
  }) {
    return LeaderboardState(
      dialogStatus: dialogStatus ?? this.dialogStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      errorTitle: errorTitle ?? this.errorTitle,
      errorBody: errorBody ?? this.errorBody,
      userList: userList ?? this.userList,
    );
  }

  @override
  List<Object?> get props => [
        dialogStatus,
        loadingMessage,
        errorBody,
        errorTitle,
        userList,
      ];
}
