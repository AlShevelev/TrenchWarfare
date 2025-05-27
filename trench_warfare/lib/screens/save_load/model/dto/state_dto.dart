/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of save_load_screen;

sealed class _SaveLoadScreenState {
  bool get isConfirmButtonEnabled;

  bool get isCloseActionEnabled;
}

class _Loading extends _SaveLoadScreenState {
  @override
  bool get isConfirmButtonEnabled => false;

  @override
  bool get isCloseActionEnabled => false;
}

class _DataIsLoaded extends _SaveLoadScreenState {
  final Iterable<_SlotDto> slots;

  @override
  bool get isCloseActionEnabled => true;

  @override
  bool get isConfirmButtonEnabled => slots.any((s) => s.selected);

  _DataIsLoaded({required this.slots});

  _DataIsLoaded copy(Iterable<_SlotDto> slots) => _DataIsLoaded(slots: slots);
}