/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_builders;

class NewGameBuilder implements GameBuilder {
  final RenderableTiledMap _tileMap;

  final Nation _selectedNation;

  static const _humanIndex = 0;

  final String _mapFileName;

  NewGameBuilder({
    required String mapFileName,
    required RenderableTiledMap tileMap,
    required Nation selectedNation,
  })  : _mapFileName = mapFileName,
        _tileMap = tileMap,
        _selectedNation = selectedNation;

  Iterable<NationRecord> _getPlayingNations(MapMetadata metadata) {
    final result = <NationRecord>[];

    final humanNation = metadata.nations.firstWhere((n) => n.code == _selectedNation);

    result.add(humanNation);    // we presume, _humanIndex is always zero

    final allEnemies = metadata.getEnemies(humanNation.code);
    final allAllies = metadata.getAllied(humanNation.code);
    final allNeutrals = metadata.getNeutral(humanNation.code);

    for (var i = 0; i < metadata.nations.length; i++) {
      if (i < allEnemies.length) {
        result.add(metadata.nations.firstWhere((n) => n.code == allEnemies[i]));
      }

      if (i < allAllies.length) {
        result.add(metadata.nations.firstWhere((n) => n.code == allAllies[i]));
      }

      if (i < allNeutrals.length) {
        result.add(metadata.nations.firstWhere((n) => n.code == allNeutrals[i]));
      }
    }

    return result;
  }

  @override
  Future<GameBuildResult> build() async {
    final metadata = await compute(MetadataReader.read, _tileMap.map);

    final gameField = await compute(
      GameFieldReader.read,
      Tuple2<Vector2, TiledMap>(_tileMap.destTileSize, _tileMap.map),
    );

    final playingNations = _getPlayingNations(metadata);

    return GameBuildResult(
      humanIndex: _humanIndex,
      isGameLoaded: false,
      mapFileName: _mapFileName,
      nationsDayNumber: List<int>.filled(playingNations.length, 0, growable: false),
      metadata: metadata,
      gameField: gameField,
      settings: GameFieldSettingsStorage(),
      conditions: GameOverConditionsCalculator(
        gameField: gameField,
        metadata: metadata,
        defeated: [],
      ),
      playingNations: playingNations.toList(growable: false),
      transfers: {},
      money: Map.fromEntries(playingNations.map((n) => MapEntry(n.code, MoneyStorage(gameField, n)))),
      humanUnitsSpeed: SettingsStorageFacade.humanUnitsSpeed,
      aiUnitsSpeed: SettingsStorageFacade.aiUnitsSpeed,
    );
  }
}
