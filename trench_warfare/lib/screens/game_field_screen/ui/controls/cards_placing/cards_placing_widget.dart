import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/card_photos.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class CardPlacingWidget extends StatelessWidget {
  final CardsPlacingControls state;

  final GameFieldForControls _gameField;

  const CardPlacingWidget({
    required this.state,
    required GameFieldForControls gameField,
    super.key,
  }) : _gameField = gameField;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        // Cancel button
        CornerButton(
          right: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_close.webp'),
          onPress: () {
            _gameField.onCardsPlacingCancelled();
          },
        ),
        GameFieldGeneralPanel(
          money: state.totalMoney,
          left: 15,
          top: 0,
        ),
        Positioned(
            left: 15,
            bottom: 15,
            child: Image.asset(
              CardPhotos.getPhoto(state.card),
              scale: 3,
            ))
      ],
    );
  }
}
