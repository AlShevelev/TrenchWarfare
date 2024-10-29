part of new_game_dto_library;

sealed class NewGameDataState {}

class Loading extends NewGameDataState {}

class DataIsReady extends NewGameDataState {
  final Tab europeTab;

  final Tab asiaTab;

  final Tab newWorldTab;

  DataIsReady({required this.europeTab, required this.asiaTab, required this.newWorldTab});

  DataIsReady copy({
    Tab? europeTab,
    Tab? asiaTab,
    Tab? newWorldTab,
  }) =>
      DataIsReady(
        europeTab: europeTab ?? this.europeTab,
        asiaTab: asiaTab ?? this.asiaTab,
        newWorldTab: newWorldTab ?? this.newWorldTab,
      );
}
