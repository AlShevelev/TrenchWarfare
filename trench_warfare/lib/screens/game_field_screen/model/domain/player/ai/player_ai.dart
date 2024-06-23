import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';

abstract class PlayerAi {
  final PlayerInput player;

  PlayerAi(this.player);

  void start();
}