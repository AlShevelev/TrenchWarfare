import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/objectives/objectives_production_center_painter.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';

class ObjectivesDialog extends StatelessWidget {
  static const _iconSize = 65.0;

  final GameFieldForControls _gameField;

  final List<Nation> _nations;

  const ObjectivesDialog({
    super.key,
    required GameFieldForControls gameField,
    required List<Nation> nations,
  })  : _gameField = gameField,
        _nations = nations;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return GestureDetector(
      onTap: () {
        audioController.playSound(SoundType.buttonClick);
        _gameField.onPopupDialogClosed();
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: DefaultTextStyle(
          style: const TextStyle(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Cardboard(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tr('objectives_text'),
                      style: AppTypography.s18w600,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _nations
                            .map((n) => [n, n])
                            .expand((n) => n)
                            .mapIndexed((index, nation) => CustomPaint(
                              painter: ObjectivesProductionCenterPainter(
                                type: index.isOdd
                                    ? ProductionCenterType.factory
                                    : ProductionCenterType.city,
                                level: ProductionCenterLevel.level2,
                                spritesAtlas: _gameField.spritesAtlas,
                                nation: nation,
                              ),
                              child: const SizedBox(
                                width: _iconSize,
                                height: _iconSize,
                                child: null,
                              ),
                            ))
                            .toList(growable: false),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
