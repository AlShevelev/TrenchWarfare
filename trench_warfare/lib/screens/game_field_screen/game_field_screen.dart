import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_controls.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class GameFieldScreen extends StatelessWidget {
  final String _mapFileName;

  final Nation? _selectedNation;

  final GameSlot? _slot;

  const GameFieldScreen({
    required mapFileName,
    Nation? selectedNation,
    GameSlot? slot,
    super.key,
  })  : _mapFileName = mapFileName,
        _selectedNation = selectedNation,
        _slot = slot;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Background(
        imagePath: 'assets/images/screens/game_field/game_field_background.webp',
        child: GameWidget(
          game: GameField(
            mapFileName: _mapFileName,
            selectedNation: _selectedNation,
            slot: _slot,
            locale: locale,
          ),
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
