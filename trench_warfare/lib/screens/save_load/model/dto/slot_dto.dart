part of save_load_screen;

sealed class _SlotDto {
  bool _selected;
  bool get selected => _selected;

  final int slotId;

  _SlotDto({required bool selected, required this.slotId}) : _selected = selected;

  void setSelected({required bool selected}) => _selected = selected;
}

class _DataSlotDto extends _SlotDto {
  final bool isAutosave;

  final String title;

  final int day;

  final DateTime saveDateTime;

  final Iterable<_SideOfConflictDto> sideOfConflict;

  _DataSlotDto({
    required super.selected,
    required super.slotId,
    required this.isAutosave,
    required this.title,
    required this.day,
    required this.saveDateTime,
    required this.sideOfConflict,
  });
}

class _EmptySlotDto extends _SlotDto {
  _EmptySlotDto({
    required super.selected,
    required super.slotId,
  });
}

class _SideOfConflictDto {
  final Nation nation;

  final bool selected;

  _SideOfConflictDto({
    required this.nation,
    required this.selected,
  });
}
