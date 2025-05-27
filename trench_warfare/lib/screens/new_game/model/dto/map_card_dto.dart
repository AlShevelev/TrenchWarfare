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

class MapCardDto {
  final String id;

  String mapName;

  String mapFileName;

  final Map<AppLocale, String> title;

  final Map<AppLocale, String> description;

  final DateTime from;

  final DateTime to;

  final int mapRows;
  final int mapCols;

  final List<SideOfConflictDto> _opponents;

  Iterable<SideOfConflictDto> get opponents => _opponents;

  final Iterable<Nation> neutrals;

  bool _selected;

  bool get selected => _selected;

  bool _expanded;

  bool get expanded => _expanded;

  MapCardDto({
    required this.id,
    required this.mapName,
    required this.mapFileName,
    required this.title,
    required this.from,
    required this.to,
    required this.description,
    required List<SideOfConflictDto> opponents,
    required this.neutrals,
    required this.mapRows,
    required this.mapCols,
    required bool selected,
    required bool expanded,
  })  : _selected = selected,
        _expanded = expanded,
        _opponents = opponents;

  void setSelected(bool selected) => _selected = selected;

  void switchExpanded() => _expanded = !_expanded;

  void setSelectedOpponent(Nation opponentNation) {
    for (var opponent in _opponents) {
      opponent.setSelected(opponent.nation == opponentNation);
    }
  }
}
