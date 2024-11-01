part of map_selection_dto_library;

enum TabCode {
  europe,
  asia,
  newWorld,
}

class Tab {
  final bool selected;

  final TabCode code;

  final Iterable<Card> cards;

  Tab({required this.selected, required this.code, required this.cards});

  Tab copy({
    bool? selected,
    Iterable<Card>? cards,
  }) =>
      Tab(
        selected: selected ?? this.selected,
        code: code,
        cards: cards ?? this.cards,
      );
}
