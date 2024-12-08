part of game_builders;

class LoadedGameBuilder implements GameBuilder {
  late final _dao = Database.saveLoadGameDao;

  final GameSlot _slot;

  LoadedGameBuilder({required GameSlot slot}): _slot = slot;

  @override
  Future<GameBuildResult> build() {
    final slotDb = _dao.readSlot(_slot.index)!;

    // TODO: implement build
    throw UnimplementedError();
  }
/*
  @override
  int get dayNumber => _slotDb.day;

  @override
  int get humanIndex => 0;

  @override
  String get mapFileName => _slotDb.mapFileName;

  @override
  Future<GameField> getGameField() {
    // TODO: implement getGameField
    throw UnimplementedError();
  }

  @override
  GameOverConditionsCalculator getGameOverConditions() {
    // TODO: implement getGameOverConditions
    throw UnimplementedError();
  }

  @override
  Future<MapMetadata> getMetadata() {
    // TODO: implement getMetadata
    throw UnimplementedError();
  }

  @override
  Iterable<NationRecord> getPlayingNations() {
    // TODO: implement getPlayingNations
    throw UnimplementedError();
  }

  @override
  GameFieldSettingsStorage getSettings() {
    final settings = _dao.readAllSettings(_slotDb.dbId).firstOrNull;

    final storage = GameFieldSettingsStorage();

    if (settings != null) {
      storage.zoom = settings.zoom;

      if (settings.cameraPositionX != null && settings.cameraPositionY != null) {
        storage.cameraPosition = Vector2(settings.cameraPositionX!, settings.cameraPositionY!);
      }
    }

    return storage;
  }

  @override
  Map<Nation, Iterable<TroopTransferReadForSaving>> getTransfers() {
    // TODO: implement getTransfers
    throw UnimplementedError();
  }*/
}