import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/objectives/objectives_production_center_painter.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';

class ObjectivesDialog extends StatelessWidget {
  static const _iconSize = 65.0;

  final GameFieldForControls _gameField;

  const ObjectivesDialog({
    super.key,
    required GameFieldForControls gameField,
  }) : _gameField = gameField;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: CustomPaint(
                                  painter: ObjectivesProductionCenterPainter(
                                    type: ProductionCenterType.city,
                                    level: ProductionCenterLevel.level2,
                                    spritesAtlas: _gameField.spritesAtlas,
                                  ),
                                  child: const SizedBox(
                                    width: _iconSize,
                                    height: _iconSize,
                                    child: null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: CustomPaint(
                                  painter: ObjectivesProductionCenterPainter(
                                    type: ProductionCenterType.factory,
                                    level: ProductionCenterLevel.level2,
                                    spritesAtlas: _gameField.spritesAtlas,
                                  ),
                                  child: const SizedBox(
                                    width: _iconSize,
                                    height: _iconSize,
                                    child: null,
                                  ),
                                ),
                              ),
                            ],
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
