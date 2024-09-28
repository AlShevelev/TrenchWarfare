import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:trench_warfare/app/navigation/fade_route.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field_screen.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

class Routes {
  static const startScreen = '/';
  static const gameField = '/game_field';
  static const debugLogging = '/debug_logging';

  static PageRouteBuilder? createPageRouteBuilder(RouteSettings settings) {
    switch (settings.name) {
      case gameField:
        {
          final mapName = settings.arguments as String;
          return FadeRoute(GameFieldScreen(mapName: mapName));
        }
      case debugLogging:
        {
          return FadeRoute(TalkerScreen(talker: Logger.talkerFlutter));
        }
      default:
        {
          return null;
        }
    }
  }
}
