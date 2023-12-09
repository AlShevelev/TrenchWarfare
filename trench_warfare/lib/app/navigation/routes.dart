import 'package:flutter/material.dart';
import 'package:trench_warfare/app/navigation/fade_route.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field_screen.dart';

class Routes {
  static const startScreen = '/';
  static const gameField = '/game_field';

  static PageRouteBuilder? createPageRouteBuilder(RouteSettings settings) {
    switch (settings.name) {
      case gameField:
        {
          final mapName = settings.arguments as String;
          return FadeRoute(GameFieldScreen(mapName: mapName));
        }
      default:
        {
          return null;
        }
    }
  }
}
