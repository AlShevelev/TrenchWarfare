part of game_builders;

class NewGameBuilder implements GameBuilder {
  final RenderableTiledMap _tileMap;

  final Nation _selectedNation;

  late final MapMetadata _metadata;

  late final GameField _gameField;

  @override
  int get humanIndex => 0;

  final String _mapFileName;
  @override
  String get mapFileName => _mapFileName;

  @override
  int get dayNumber => 0;

  NewGameBuilder({
    required String mapFileName,
    required RenderableTiledMap tileMap,
    required Nation selectedNation,
  })  : _mapFileName = mapFileName,
        _tileMap = tileMap,
        _selectedNation = selectedNation;

  @override
  GameOverConditionsCalculator getGameOverConditions() {
    return GameOverConditionsCalculator(
      gameField: _gameField,
      metadata: _metadata,
      defeated: [],
    );
  }

  @override
  Future<GameField> getGameField() async {
    _gameField = await compute(
      GameFieldReader.read,
      Tuple2<Vector2, TiledMap>(_tileMap.destTileSize, _tileMap.map),
    );

    return _gameField;
  }

  @override
  Future<MapMetadata> getMetadata() async {
    _metadata = await compute(MetadataReader.read, _tileMap.map);
    return _metadata;
  }

  @override
  Iterable<NationRecord> getPlayingNations() {
    final result = <NationRecord>[..._metadata.nations];

    final firstAggressive = result
        .indexWhere((it) => it.aggressiveness == Aggressiveness.aggressive && it.code == _selectedNation);

    if (firstAggressive != humanIndex) {
      result.insert(humanIndex, result.removeAt(firstAggressive));
    }

    return result;
  }

  @override
  GameFieldSettingsStorage getSettings() => GameFieldSettingsStorage();

  @override
  Map<Nation, Iterable<TroopTransferReadForSaving>> getTransfers() => {};
}
