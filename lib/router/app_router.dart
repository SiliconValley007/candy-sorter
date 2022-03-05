import 'package:candy_sorter/constants/constants.dart';
import 'package:candy_sorter/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

/// AppRouter class to handle our MaterialApp navigation
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case startGame:
        return StartGameScreen.route();
      case gameScreen:
        return GameScreen.route();
      case settingsScreen:
        return SettingsScreen.route();
      default:
        return StartGameScreen.route();
    }
  }
}
