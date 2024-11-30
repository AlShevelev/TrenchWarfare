part of game_field;

class PathItem {
  final PathItemType type;

  final bool isActive;

  /// How many movement point do you need to move from a previous cell to this one
  final double movementPointsLeft;

  PathItem({required this.type, required this.isActive, required this.movementPointsLeft});

  @override
  String toString() =>
      'PATH_ITEM: {type: $type; isActive: $isActive; movementPointsLeft: $movementPointsLeft}';
}
