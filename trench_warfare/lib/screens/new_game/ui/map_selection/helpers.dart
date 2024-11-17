part of map_selection_ui;

extension _TabCodeExt on TabCode {
  String get uiString => switch (this) {
    TabCode.europe => 'europe',
    TabCode.asia => 'asia',
    TabCode.newWorld => 'new_world',
  };
}
