part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object?> get props => [];
}

class DiceRolled extends HomePageEvent {
  const DiceRolled();
}

class HomePageInitial extends HomePageEvent {
  const HomePageInitial();
}

class LogOut extends HomePageEvent {
  const LogOut();
}
