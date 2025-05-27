/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of navigation;

class Routes {
  static const cover = '/';
  static const fromCoverToMapSelection = '/from_cover_to_map_selection';
  static const fromCoverToLoadGame = '/from_cover_to_loadGame';
  static const fromMapSelectionToGameFieldNewGame = '/from_map_selection_to_game_field_new_game';
  static const fromLoadToGameFieldLoadGame = '/from_load_to_game_field_load_game';
  static const fromCoverToDebugLogging = '/from_cover_to_debug_logging';
  static const fromCoverToSettings = '/from_cover_to_settings';

  static PageRouteBuilder? createPageRouteBuilder(RouteSettings settings) {
    Logger.info('route: ${settings.name}', tag: 'NAVIGATION');

    switch (settings.name) {
      case cover:
        {
          return _FadeRoute(const CoverScreen());
        }
      case fromCoverToMapSelection:
        {
          return _FadeRoute(const NewGameScreen());
        }
      case fromCoverToLoadGame:
        {
          return _FadeRoute(const SaveLoadScreen());
        }
      case fromMapSelectionToGameFieldNewGame:
        {
          final args = settings.arguments as NewGameToGameFieldNavArg;
          Logger.info('route arguments: mapName: ${args.mapName}; nation: ${args.selectedNation}',
              tag: 'NAVIGATION');

          return _FadeRoute(
            GameFieldScreen(
              mapFileName: args.mapName,
              selectedNation: args.selectedNation,
            ),
          );
        }
      case fromLoadToGameFieldLoadGame:
        {
          final args = settings.arguments as LoadGameToGameFieldNavArg;
          Logger.info('route arguments: mapFileName: ${args.mapFileName}; slot: ${args.slot}',
              tag: 'NAVIGATION');

          return _FadeRoute(
            GameFieldScreen(
              mapFileName: args.mapFileName,
              slot: args.slot,
            ),
          );
        }
      case fromCoverToDebugLogging:
        {
          return _FadeRoute(TalkerScreen(talker: Logger.talkerFlutter));
        }
      case fromCoverToSettings:
        {
          return _FadeRoute(const SettingsScreen());
        }
      default:
        {
          return null;
        }
    }
  }
}
