part of aggressive_player_ai;

abstract interface class MovementRegistry {
  Goal? getGoal(String unitId);

  void addGoal(String unitId, Goal goal);

  void updateGoal(String unitId, Goal goal);

  void removeGoal(String unitId);

  /// Removes all records with keys NOT in the list
  void exclude(Iterable<String> unitIds);
}

class MovementRegistryImpl implements MovementRegistry {
  @override
  Goal? getGoal(String unitId) {
    // TODO: implement getGoal
    throw UnimplementedError();
  }

  @override
  void addGoal(String unitId, Goal goal) {
    // TODO: implement addGoal
  }

  @override
  void removeGoal(String unitId) {
    // TODO: implement removeGoal
  }

  @override
  void updateGoal(String unitId, Goal goal) {
    // TODO: implement updateGoal
  }

  @override
  void exclude(Iterable<String> unitIds) {
    // TODO: implement updateGoal
  }
}