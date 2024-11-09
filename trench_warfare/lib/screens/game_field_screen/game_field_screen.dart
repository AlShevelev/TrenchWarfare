import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_controls.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class GameFieldScreen extends StatelessWidget {
  final String _mapName;

  final Nation _selectedNation;

  const GameFieldScreen({
    required mapName,
    required Nation selectedNation,
    super.key,
  })  : _mapName = mapName,
        _selectedNation = selectedNation;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Background.path(
        imagePath: 'assets/images/screens/game_field/game_field_background.webp',
        child: GameWidget(
          game: GameField(mapName: _mapName, selectedNation: _selectedNation),
          overlayBuilderMap: {
            GameFieldControls.overlayKey: (BuildContext context, GameField gameField) {
              return GameFieldControls(gameField);
            },
          },
        ),
      ),
    );
  }
}
