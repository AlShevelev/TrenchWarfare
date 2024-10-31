part of map_selection_dto_library;

class Card {
  final String id;

  final Map<AppLocale, String> title;

  final Map<AppLocale, String> description;

  final DateTime from;

  final DateTime to;

  final Iterable<SideOfConflict> opponents;

  final Iterable<Nation> neutrals;

  final bool selected;

  Card({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.description,
    required this.opponents,
    required this.neutrals,
    required this.selected,
  });

  Card copy({
    String? id,
    Map<AppLocale, String>? title,
    DateTime? from,
    DateTime? to,
    Map<AppLocale, String>? description,
    Iterable<SideOfConflict>? opponents,
    Iterable<Nation>? neutrals,
    bool? selected,
  }) =>
      Card(
        id: id ?? this.id,
        title: title ?? this.title,
        from: from ?? this.from,
        to: to ?? this.to,
        description: description ?? this.description,
        opponents: opponents ?? this.opponents,
        neutrals: neutrals ?? this.neutrals,
        selected: selected ?? this.selected,
      );
}
