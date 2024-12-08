part of game_builders;

abstract interface class GameBuilder {
  Future<GameBuildResult> build();
}