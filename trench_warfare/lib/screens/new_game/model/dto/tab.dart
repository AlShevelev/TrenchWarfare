part of map_selection_dto_library;

class Tab {
  final bool selected;

  final Iterable<Card> cards;

  Tab({required this.selected, required this.cards});

  Tab copy({
    bool? selected,
    Iterable<Card>? cards,
  }) =>
      Tab(
        selected: selected ?? this.selected,
        cards: cards ?? this.cards,
      );
}
