part of game_field_sm;

class GameFieldStateMachineContext {
  final GameFieldRead gameField;

  final Nation myNation;

  final Nation humanNation;

  final MoneyStorage money;

  final MapMetadataRead mapMetadata;

  final GameFieldSettingsStorageRead gameFieldSettingsStorage;

  final SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent;

  final SimpleStream<GameFieldControlsState> controlsState;

  final bool isAI;

  final DayStorage dayStorage;

  final GameOverConditionsCalculator gameOverConditionsCalculator;

  final GameFieldModelCallback modelCallback;

  final AnimationTimeFacade animationTimeFacade;

  final MovementResultBridge? movementResultBridge;

  GameFieldStateMachineContext({
    required this.gameField,
    required this.myNation,
    required this.humanNation,
    required this.money,
    required this.mapMetadata,
    required this.gameFieldSettingsStorage,
    required this.updateGameObjectsEvent,
    required this.controlsState,
    required this.isAI,
    required this.dayStorage,
    required this.gameOverConditionsCalculator,
    required this.modelCallback,
    required this.animationTimeFacade,
    required this.movementResultBridge,
  });
}
