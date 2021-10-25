import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? userName;
  final int? score;

  User({this.userName, this.score});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(userName: json['userName'], score: json['score']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['score'] = this.score;
    return data;
  }

  @override
  List<Object?> get props => [userName, score];
}
