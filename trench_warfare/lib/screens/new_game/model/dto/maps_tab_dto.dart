part of map_selection_dto_library;

enum TabCode {
  europe,
  asia,
  newWorld,
}

class MapTabDto {
  final bool selected;

  final TabCode code;

  final Iterable<MapCardDto> cards;

  MapTabDto({required this.selected, required this.code, required this.cards});

  MapTabDto copy({
    bool? selected,
    Iterable<MapCardDto>? cards,
  }) =>
      MapTabDto(
        selected: selected ?? this.selected,
        code: code,
        cards: cards ?? this.cards,
      );
}
