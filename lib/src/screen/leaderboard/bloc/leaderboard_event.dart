part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialLeaderboard extends LeaderboardEvent {
  const LoadInitialLeaderboard();
}
