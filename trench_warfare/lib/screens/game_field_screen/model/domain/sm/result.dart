/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_sm;

sealed class Result {}

class Done implements Result {
  Done();

  @override
  String toString() => 'SM_RESULT: DONE';
}

class BlockedByDialog implements Result {
  BlockedByDialog();

  @override
  String toString() => 'SM_RESULT: BLOCKED_BY_DIALOG';
}
