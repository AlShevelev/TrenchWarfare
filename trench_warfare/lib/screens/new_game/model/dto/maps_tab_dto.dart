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

enum TabCode {
  europe,
  asia,
  newWorld,
}

class MapTabDto {
  bool _selected;
  bool get selected => _selected;

  final TabCode code;

  final List<MapCardDto> _cards;
  Iterable<MapCardDto> get cards => _cards;

  MapTabDto({required bool selected, required this.code, required List<MapCardDto> cards})
      : _selected = selected,
        _cards = cards;

  void setSelected(bool selected) => _selected = selected;
}
