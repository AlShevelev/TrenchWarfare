part of map_selection_dto_library;

class MapCardDto {
  final String id;

  /// Without .tmx
  String mapName;

  final Map<AppLocale, String> title;

  final Map<AppLocale, String> description;

  final DateTime from;

  final DateTime to;

  final Iterable<SideOfConflictDto> opponents;

  final Iterable<Nation> neutrals;

  final bool selected;

  MapCardDto({
    required this.id,
    required this.mapName,
    required this.title,
    required this.from,
    required this.to,
    required this.description,
    required this.opponents,
    required this.neutrals,
    required this.selected,
  });

  MapCardDto copy({
    Map<AppLocale, String>? title,
    DateTime? from,
    DateTime? to,
    Map<AppLocale, String>? description,
    Iterable<SideOfConflictDto>? opponents,
    Iterable<Nation>? neutrals,
    bool? selected,
  }) =>
      MapCardDto(
        id: id,
        mapName: mapName,
        title: title ?? this.title,
        from: from ?? this.from,
        to: to ?? this.to,
        description: description ?? this.description,
        opponents: opponents ?? this.opponents,
        neutrals: neutrals ?? this.neutrals,
        selected: selected ?? this.selected,
      );
}
