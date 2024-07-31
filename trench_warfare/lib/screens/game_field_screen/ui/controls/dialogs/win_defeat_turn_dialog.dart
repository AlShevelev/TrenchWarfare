import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

enum WinDefeatTurnDialogType { win, defeat, defeatGlobal, turn }

class WinDefeatTurnDialog extends StatelessWidget {
  final WinDefeatTurnDialogType type;
  final Nation nation;
  final int? day;

  final GameFieldForControls _gameField;

  static const _imagesPath = 'assets/images/game_field_overlays/dialogs/win_defeat_turn/';
  static const _background = '${_imagesPath}card_background.webp';

  const WinDefeatTurnDialog({
    super.key,
    required this.type,
    required this.nation,
    this.day,
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
              child: Container(
                  //color: Colors.red,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_background),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(_getBanner()),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Text(
                                    _getTitle(),
                                    style: AppTypography.s18w600,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Image.asset(_getBanner()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            _getPhoto(),
                            fit: BoxFit.fitWidth,
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

  String _getPhoto() => switch (type) {
        WinDefeatTurnDialogType.win => '${_imagesPath}photos/photo_victory.webp',
        WinDefeatTurnDialogType.defeat ||
        WinDefeatTurnDialogType.defeatGlobal =>
          '${_imagesPath}photos/photo_defeat.webp',
        WinDefeatTurnDialogType.turn =>
          '${_imagesPath}photos/photo_new_turn_${RandomGen.randomInt(4) + 1}.webp',
      };

  String _getBanner() => '${_imagesPath}banners/${nation.name}.webp';

  String _getTitle() => switch (type) {
        WinDefeatTurnDialogType.win => tr('victory_dialog'),
        WinDefeatTurnDialogType.defeat => tr('defeat_dialog'),
        WinDefeatTurnDialogType.defeatGlobal => tr('defeat_dialog_global'),
        WinDefeatTurnDialogType.turn => '${tr('day_dialog')} ${day!}',
      };
}
