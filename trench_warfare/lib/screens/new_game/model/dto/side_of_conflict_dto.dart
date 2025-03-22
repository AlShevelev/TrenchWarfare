part of map_selection_dto_library;

class SideOfConflictDto {
  final Nation nation;

  bool _selected;

  bool get selected => _selected;

  /// To group allies
  final int groupId;

  SideOfConflictDto({
    required this.nation,
    required bool selected,
    required this.groupId,
  }) : _selected = selected;

  void setSelected(bool selected) => _selected = selected;
}
