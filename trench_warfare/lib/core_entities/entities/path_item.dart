import 'package:trench_warfare/core_entities/enums/path_item_type.dart';

class PathItem {
  final PathItemType type;

  final bool isActive;

  /// How many movement point do you need to move from a previous cell to this one
  final double moveToCellCost;

  PathItem({required this.type, required this.isActive, required this.moveToCellCost});
}