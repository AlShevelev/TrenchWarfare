/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

class _CardDto<T> {
  final int indexInTab;

  bool _selected;
  bool get selected => _selected;

  bool _expanded;
  bool get expanded => _expanded;

  final bool canBuild;

  final GameFieldControlsCard<T> card;

  _CardDto({
    required this.indexInTab,
    required bool selected,
    required bool expanded,
    required this.canBuild,
    required this.card,
  })  : _selected = selected,
        _expanded = expanded;

  void setSelected(bool selected) => _selected = selected;

  void setExpended(bool expanded) => _expanded = expanded;
}
