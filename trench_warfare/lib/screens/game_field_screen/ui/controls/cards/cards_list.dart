import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards/units_card.dart';

class CardsList extends StatefulWidget {
  late final List<GameFieldControlsUnitCard> _units;

  CardsList({super.key, required List<GameFieldControlsUnitCard> units}) {
    _units = units;
  }

  @override
  State<StatefulWidget> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<UnitsCard> allCards = [];

    allCards.addAll(
        widget._units.asMap().entries.map((u) {
          return UnitsCard(
            unit: u.value,
            selected: u.key == selectedIndex,
            index: u.key,
            onClick: (index) {
              allCards[selectedIndex].updateSelection(false);
              selectedIndex = index;
              allCards[selectedIndex].updateSelection(true);
            },
          );
        })
    );


    return ListView(
      children: allCards,
    );
  }
}