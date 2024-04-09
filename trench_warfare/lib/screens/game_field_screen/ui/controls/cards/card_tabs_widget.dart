import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards/cards_tab.dart';

class CardTabsWidgets extends StatefulWidget {
  late final void Function(CardsTab) _onSwitchTab;

  CardTabsWidgets({super.key, required void Function(CardsTab) onSwitchTab}) {
    _onSwitchTab = onSwitchTab;
  }

  @override
  State<CardTabsWidgets> createState() => _CardTabsWidgetsState();
}

class _CardTabsWidgetsState extends State<CardTabsWidgets> {
  static const double _inactiveTabPadding = 15;

  static const double _bookmarkWidth = 50;
  static const double _bookmarkHeight = 83;

  static const double _bookmarkStartOffset = 40;
  static const double _bookmarksGap = 10;

  CardsTab _activeTab = CardsTab.units;
  CardsTab get activeTab => _activeTab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        _getBookmark(
          index: 0,
          tab: CardsTab.units,
          folder: 'units',
        ),
        _getBookmark(
          index: 1,
          tab: CardsTab.productionCenters,
          folder: 'production_centers',
        ),
        _getBookmark(
          index: 2,
          tab: CardsTab.terrainModifiers,
          folder: 'terrain_modifiers',
        ),
        _getBookmark(
          index: 3,
          tab: CardsTab.troopBoosters,
          folder: 'troop_boosters',
        ),
        _getBookmark(
          index: 4,
          tab: CardsTab.specialStrikes,
          folder: 'special_strikes',
        ),
      ],
    );
  }

  Widget _getBookmark({required int index, required CardsTab tab, required String folder}) =>
      Positioned(
        left: _bookmarkStartOffset + index * (_bookmarkWidth + _bookmarksGap),
        top: _activeTab == tab ? 0 : _inactiveTabPadding,
        width: _bookmarkWidth,
        height: _bookmarkHeight,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _activeTab = tab;
              widget._onSwitchTab(tab);
            });
          },
          child: Image.asset('assets/images/game_field_overlays/cards/$folder/bookmark.webp'),
        ),
      );
}