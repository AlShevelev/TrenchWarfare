part of navigation;

class Routes {
  static const coverScreen = '/';
  static const newGame = '/newGame';
  static const loadGame = '/loadGame';
  static const gameField = '/game_field';
  static const debugLogging = '/debug_logging';

  static PageRouteBuilder? createPageRouteBuilder(RouteSettings settings) {
    switch (settings.name) {
      case coverScreen:
        {
          Logger.info('to: coverScreen', tag: 'NAVIGATION');
          return _FadeRoute(const CoverScreen());
        }
      case newGame:
        {
          Logger.info('to: newGame', tag: 'NAVIGATION');
          return _FadeRoute(const NewGameScreen());
        }
      case loadGame:
        {
          Logger.info('to: loadGame', tag: 'NAVIGATION');
          return _FadeRoute(const SaveLoadScreen());
        }
      case gameField:
        {
          final mapName = settings.arguments as NewGameToGameFieldNavArg;
          Logger.info('to: gameField; mapName: ${mapName.mapName}; nation: ${mapName.selectedNation}',
              tag: 'NAVIGATION');

          return _FadeRoute(
            GameFieldScreen(
              mapName: mapName.mapName,
              selectedNation: mapName.selectedNation,
            ),
          );
        }
      case debugLogging:
        {
          Logger.info('to: debugLogging', tag: 'NAVIGATION');
          return _FadeRoute(TalkerScreen(talker: Logger.talkerFlutter));
        }
      default:
        {
          return null;
        }
    }
  }
}
