part of map_selection_dto_library;

class SideOfConflictDto {
  final Nation nation;

  bool _selected;
  bool get selected => _selected;

  SideOfConflictDto({required this.nation, required bool selected}): _selected = selected;

  void setSelected(bool selected) => _selected = selected;
}
