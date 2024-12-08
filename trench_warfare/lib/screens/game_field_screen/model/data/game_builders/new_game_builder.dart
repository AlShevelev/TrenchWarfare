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
    final result = <NationRecord>[...metadata.nations];

    final firstAggressive = result
        .indexWhere((it) => it.aggressiveness == Aggressiveness.aggressive && it.code == _selectedNation);

    if (firstAggressive != _humanIndex) {
      result.insert(_humanIndex, result.removeAt(firstAggressive));
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
      mapFileName: _mapFileName,
      dayNumber: 0,
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
    );
  }
}
