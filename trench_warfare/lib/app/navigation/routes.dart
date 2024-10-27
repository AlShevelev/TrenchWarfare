import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:trench_warfare/app/navigation/fade_route.dart';
import 'package:trench_warfare/screens/cover/cover_screen.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field_screen.dart';
import 'package:trench_warfare/screens/new_game/ui/new_game_screen.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

class Routes {
  static const coverScreen = '/';
  static const newGame = '/newGame';
  static const gameField = '/game_field';
  static const debugLogging = '/debug_logging';

  static PageRouteBuilder? createPageRouteBuilder(RouteSettings settings) {
    switch (settings.name) {
      case coverScreen:
        {
          Logger.info('to: coverScreen', tag: 'NAVIGATION');

          return FadeRoute(const CoverScreen());
        }
      case newGame:
        {
          Logger.info('to: newGame', tag: 'NAVIGATION');

          return FadeRoute(const NewGameScreen());
        }
      case gameField:
        {
          final mapName = settings.arguments as String;
          Logger.info('to: gameField; mapName: $mapName', tag: 'NAVIGATION');

          return FadeRoute(GameFieldScreen(mapName: mapName));
        }
      case debugLogging:
        {
          Logger.info('to: debugLogging', tag: 'NAVIGATION');
          return FadeRoute(TalkerScreen(talker: Logger.talkerFlutter));
        }
      default:
        {
          return null;
        }
    }
  }
}
