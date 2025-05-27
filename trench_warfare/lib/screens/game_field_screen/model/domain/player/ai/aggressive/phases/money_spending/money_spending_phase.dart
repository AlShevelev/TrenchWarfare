/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of money_spending_phase_library;

class MoneySpendingPhase with InfluenceMapPhases implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

  final MapMetadataRead _metadata;

  final SimpleStream<GameFieldControlsState> _aiProgressState;

  final UnitUpdateResultBridgeRead _unitUpdateResultBridge;

  static const String tag = 'MONEY_SPENDING';

  MoneySpendingPhase({
    required PlayerInput player,
    required GameFieldRead gameField,
    required Nation myNation,
    required MoneyStorageRead nationMoney,
    required MapMetadataRead metadata,
    required SimpleStream<GameFieldControlsState> aiProgressState,
    required UnitUpdateResultBridgeRead unitUpdateResultBridge,
  })  : _player = player,
        _gameField = gameField,
        _myNation = myNation,
        _nationMoney = nationMoney,
        _metadata = metadata,
        _aiProgressState = aiProgressState,
        _unitUpdateResultBridge = unitUpdateResultBridge;

  @override
  Future<void> start() async {
    final startMoney = _nationMoney.totalSum.currency.toDouble();
    _aiProgressState.update(AiTurnProgress(moneySpending: 0.0, unitMovement: 0.0));

    final influences = await calculateFullInfluenceMap(_myNation, _metadata, _gameField);

    while (true) {
      Logger.info('loop started', tag: tag);

      Logger.info('influences map is calculated', tag: tag);

      final List<_EstimationProcessor> processors = [
        _ProductionCenterEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
          unitUpdateResultBridge: _unitUpdateResultBridge,
        ),
        _AirFieldEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
          unitUpdateResultBridge: _unitUpdateResultBridge,
        ),
        _SpecialStrikeEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
          unitUpdateResultBridge: _unitUpdateResultBridge,
        ),
        _TerrainModifierEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
          unitUpdateResultBridge: _unitUpdateResultBridge,
        ),
        _UnitBoosterEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
          unitUpdateResultBridge: _unitUpdateResultBridge,
        ),
        _UnitsEstimationProcessor(
          player: _player,
          gameField: _gameField,
          myNation: _myNation,
          nationMoney: _nationMoney,
          metadata: _metadata,
          influenceMap: influences,
          unitUpdateResultBridge: _unitUpdateResultBridge,
        ),
      ];

      if (!_metadata.landOnlyAi) {
        processors.add(
          _CarriersEstimationProcessor(
            player: _player,
            gameField: _gameField,
            myNation: _myNation,
            nationMoney: _nationMoney,
            metadata: _metadata,
            influenceMap: influences,
            unitUpdateResultBridge: _unitUpdateResultBridge,
          ),
        );
      }

      final averageWeights = processors.map((p) => p.estimate()).toList(growable: false);

      Logger.info(
        'calculated weights are: ${averageWeights.map((e) => e.toString()).join(' ,')}',
        tag: tag,
      );

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

      Logger.info('selected index is: $generalActionIndex', tag: tag);

      // We can't make a general decision. The presumable reason - we're short of money, or build
      // everything we can
      if (generalActionIndex == null) {
        break;
      }

      final selectedProcessor = processors[generalActionIndex];

      // It's a dirty, but necessary hack
      final playerCore = _player as PlayerCore;
      playerCore.registerOnAnimationCompleted(() {
        selectedProcessor.onAnimationCompleted();
      });

      try {
        Logger.info('selectedProcessor.process() started', tag: tag);
        final processingResult = await selectedProcessor.process();
        Logger.info('selectedProcessor.process() completed', tag: tag);

        updateInfluenceMap(influences, processingResult);
      } catch (e, s) {
        Logger.error(e.toString(), stackTrace: s);
      } finally {
        playerCore.registerOnAnimationCompleted(null);
      }

      _aiProgressState.update(
        AiTurnProgress(
          moneySpending: 1.0 - _nationMoney.totalSum.currency / startMoney,
          unitMovement: 0.0,
        ),
      );
    }

    _aiProgressState.update(AiTurnProgress(moneySpending: 1.0, unitMovement: 0.0));
  }
}
