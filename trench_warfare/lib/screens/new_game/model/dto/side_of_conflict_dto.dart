/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of map_selection_dto_library;

class SideOfConflictDto {
  final Nation nation;

  bool _selected;

  bool get selected => _selected;

  /// To group allies
  final int groupId;

  /// Completed by human on some map
  final bool completed;

  SideOfConflictDto({
    required this.nation,
    required bool selected,
    required this.groupId,
    required this.completed,

  }) : _selected = selected;

  void setSelected(bool selected) => _selected = selected;
}
