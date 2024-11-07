part of map_selection_dto_library;

class MapCardDto {
  final String id;

  /// Without .tmx
  String mapName;

  final Map<AppLocale, String> title;

  final Map<AppLocale, String> description;

  final DateTime from;

  final DateTime to;

  final List<SideOfConflictDto> _opponents;
  Iterable<SideOfConflictDto> get opponents => _opponents;

  final Iterable<Nation> neutrals;

  bool _selected;
  bool get selected => _selected;

  MapCardDto({
    required this.id,
    required this.mapName,
    required this.title,
    required this.from,
    required this.to,
    required this.description,
    required List<SideOfConflictDto> opponents,
    required this.neutrals,
    required bool selected,
  }) : _selected = selected,
    _opponents = opponents;

  void setSelected(bool selected) => _selected = selected;

  void setSelectedOpponent(Nation opponentNation) {
    for (var opponent in _opponents) {
      opponent.setSelected(opponent.nation == opponentNation);
    }
  }
}
