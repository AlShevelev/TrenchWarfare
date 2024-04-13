import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards/cards_bookmarks.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards/cards_list.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';

class CardsScreen extends StatefulWidget {
  final Cards state;

  late final GameFieldForControls _gameField;

  CardsScreen({required this.state, required GameFieldForControls gameField, super.key}) {
    _gameField = gameField;
  }

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> with ImageLoading {

  bool _isBackgroundLoaded = false;

  late final ui.Image _background;
  late final ui.Image _oldBookCover;
  late final ui.Image _oldPaper;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    _background = await loadImage('assets/images/game_field_overlays/cards/background.webp');
    _oldBookCover = await loadImage('assets/images/game_field_overlays/cards/old_book_cover.webp');
    _oldPaper = await loadImage('assets/images/game_field_overlays/cards/old_paper.webp', completeCallback: () {
      setState(() {
        _isBackgroundLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBackgroundLoaded) {
      return const SizedBox.shrink();
    }

    return Background.image(
      image: _background,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 36, 7, 36),
            child: Background.image(
              image: _oldBookCover,
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  CardsBookmarks(onSwitchTab: (selectedTab) {},),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                    child: Background.image(
                      image: _oldPaper,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        alignment: AlignmentDirectional.topCenter,
                        child: CardsList(units: widget.state.units),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Select button
          GameFieldCornerButton(
            left: 15,
            bottom: 15,
            image: const AssetImage('assets/images/game_field_overlays/cards/button_select.webp'),
            onPress: () { },
          ),
          // Close button
          GameFieldCornerButton(
            right: 15,
            bottom: 15,
            image: const AssetImage('assets/images/game_field_overlays/cards/button_close.webp'),
            onPress: () { widget._gameField.onCardsClose(); },
          ),
          GameFieldGeneralPanel(
            money: widget.state.totalMoney,
            left: 15,
            top: 0,
          ),
        ],
      ),
    );
  }
}