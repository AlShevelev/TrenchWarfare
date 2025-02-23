part of movement;

enum MovementResulType {
  before,
  after,
}

class MovementResultItem {
  final Nation nation;

  final Unit unit;

  final GameFieldCellRead cell;

  final MovementResulType type;

  MovementResultItem({
    required this.nation,
    required this.unit,
    required this.cell,
    required this.type,
  });
}
