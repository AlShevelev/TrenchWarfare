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

class _TabDto<T> {
  final _TabCode code;

  bool _selected;
  bool get selected => _selected;

  final List<_CardDto<T>> _cards;
  Iterable<_CardDto<T>> get cards => _cards;

  _TabDto({
    required this.code,
    required bool selected,
    required List<_CardDto<T>> cards,
  })  : _selected = selected,
        _cards = cards;

  void setSelected(bool selected) => _selected = selected;
}
