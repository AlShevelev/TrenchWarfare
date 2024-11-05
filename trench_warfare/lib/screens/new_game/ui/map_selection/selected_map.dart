part of map_selection_ui;

class _SelectedMap {
  final String id;

  final Nation player;

  _SelectedMap({required this.id, required this.player});

  _SelectedMap copy(String? id, Nation? player) =>
      _SelectedMap(id: id ?? this.id, player: player ?? this.player);
}
