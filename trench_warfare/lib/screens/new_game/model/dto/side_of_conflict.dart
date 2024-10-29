part of new_game_dto_library;

class SideOfConflict {
  final Nation nation;

  final bool selected;

  SideOfConflict({required this.nation, required this.selected});

  SideOfConflict copy({Nation? nation, bool? selected}) => SideOfConflict(
        nation: nation ?? this.nation,
        selected: selected ?? this.selected,
      );
}
