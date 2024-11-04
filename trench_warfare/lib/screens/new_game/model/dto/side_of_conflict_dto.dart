part of map_selection_dto_library;

class SideOfConflictDto {
  final Nation nation;

  final bool selected;

  SideOfConflictDto({required this.nation, required this.selected});

  SideOfConflictDto copy({Nation? nation, bool? selected}) => SideOfConflictDto(
        nation: nation ?? this.nation,
        selected: selected ?? this.selected,
      );
}
