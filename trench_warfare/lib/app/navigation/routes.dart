part of navigation;

class Routes {
  static const coverScreen = '/';
  static const newGame = '/newGame';
  static const loadGame = '/loadGame';
  static const gameFieldNewGame = '/game_field_new_game';
  static const gameFieldLoadGame = '/game_field_load_game';
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
      case gameFieldNewGame:
        {
          final args = settings.arguments as NewGameToGameFieldNavArg;
          Logger.info('to: gameField for a new game; mapName: ${args.mapName}; nation: ${args.selectedNation}',
              tag: 'NAVIGATION');

          return _FadeRoute(
            GameFieldScreen(
              mapFileName: args.mapName,
              selectedNation: args.selectedNation,
            ),
          );
        }
      case gameFieldLoadGame:
        {
          final args = settings.arguments as LoadGameToGameFieldNavArg;
          Logger.info('to: gameField for loading game; mapFileName: ${args.mapFileName}; slot: ${args.slot}',
              tag: 'NAVIGATION');

          return _FadeRoute(
            GameFieldScreen(
              mapFileName: args.mapFileName,
              slot: args.slot,
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
