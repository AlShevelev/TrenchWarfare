/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of map_selection_ui;

extension _TabCodeExt on TabCode {
  String get uiString => switch (this) {
    TabCode.europe => 'europe',
    TabCode.asia => 'asia',
    TabCode.newWorld => 'new_world',
  };
}
