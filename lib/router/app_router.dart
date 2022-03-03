import 'package:candy_sorter/constants/constants.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case startGame:
        return StartGameScreen.route();
      case gameScreen:
        return GameScreen.route();
      default:
        return StartGameScreen.route();
    }
  }
}
