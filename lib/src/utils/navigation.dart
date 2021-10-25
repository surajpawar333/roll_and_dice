import 'package:flutter/material.dart';
import 'package:roll_dice_demo/src/screen/home_page/home_page.dart';
import 'package:roll_dice_demo/src/screen/leaderboard/view/leaderboard.dart';

import '../screen/login/login.dart';
import 'constants.dart';

class Navigation {
  static final Navigation _navigationInstance = Navigation._internal();

  factory Navigation() {
    return _navigationInstance;
  }

  Navigation._internal();

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  final routes = <String, WidgetBuilder>{
    ConstantStrings.route_login: (context) => LoginPage(),
    ConstantStrings.route_homepage: (context) => HomePage(),
    ConstantStrings.route_leaderboard: (context) => LeaderBoard(),
  };
}
