import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/money_panel.dart';

class UnitsCard extends StatefulWidget {
  final GameFieldControlsUnitCard unit;

  final ValueNotifier<bool> _selected = ValueNotifier(false);

  late final int index;

  late final void Function(int) _onClick;

  UnitsCard({
    super.key,
    required this.unit,
    required bool selected,
    required this.index,
    required void Function(int) onClick,
  }) {
    _selected.value = selected;
    _onClick = onClick;
  }

  @override
  State<StatefulWidget> createState() => _UnitsCardState();

  void updateSelection(bool selected) => _selected.value = selected;
}

class _UnitsCardState extends State<UnitsCard> {
  static const _imagesPath = 'assets/images/game_field_overlays/cards/';
  static const _unitsPath = '${_imagesPath}units/';

  bool _collapsed = true;

  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget._selected.value;

    widget._selected.addListener(() {
      setState(() {
        _selected = widget._selected.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> shadow = [];
    if (_selected) {
      shadow.add(
        const BoxShadow(
          color: AppColors.black,
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      );
    }

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_selected) {
              widget._onClick(widget.index);
            }
          },
          child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('${_unitsPath}card_background.webp'),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: shadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(
                        _getTitle(widget.unit.type),
                        style: AppTypography.s20w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Image.asset(_getPhoto(widget.unit.type)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: _getFeaturesPanel(widget.unit),
                    ),
                    _getDescription(widget.unit.type),
                    _getFooter(widget.unit),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _getFooter(GameFieldControlsUnitCard unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MoneyPanel(
          money: unit.cost,
          smallFont: true,
          stretch: false,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _collapsed = !_collapsed;
            });
          },
          child: Image.asset(
            '$_imagesPath${_collapsed ? 'icon_expand.webp' : 'icon_collapse.webp'}',
            scale: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _getFeaturesPanel(GameFieldControlsUnitCard unit) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFeature(unit.maxHealth.toString(), '${_unitsPath}icon_health.webp'),
          _getFeature(unit.attack.toString(), '${_unitsPath}icon_attack.webp'),
          _getFeature(unit.defence.toString(), '${_unitsPath}icon_defence.webp'),
          _getFeature('${unit.damage.min}-${unit.damage.max}', '${_unitsPath}icon_damage.webp'),
          _getFeature(unit.movementPoints.toInt().toString(), '${_unitsPath}icon_speed.webp'),
        ],
      );

  Widget _getFeature(String text, String icon) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          icon,
          scale: 1.15,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: AppTypography.s22w600.fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = AppColors.black,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: AppTypography.s22w600.fontSize,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  String _getTitle(UnitType type) => switch (type) {
        UnitType.armoredCar => tr('armored_car_card_name'),
        UnitType.artillery => tr('artillery_card_name'),
        UnitType.infantry => tr('infantry_card_name'),
        UnitType.cavalry => tr('cavalry_card_name'),
        UnitType.machineGunnersCart => tr('machine_gunners_cart_card_name'),
        UnitType.machineGuns => tr('machine_gunners_card_name'),
        UnitType.tank => tr('tank_card_name'),
        UnitType.destroyer => tr('destroyer_card_name'),
        UnitType.cruiser => tr('cruiser_card_name'),
        UnitType.battleship => tr('battleship_card_name'),
        UnitType.carrier => tr('carrier_card_name'),
      };

  Widget _getDescription(UnitType type) {
    final text = switch (type) {
      UnitType.armoredCar => tr('armored_car_card_description'),
      UnitType.artillery => tr('artillery_card_description'),
      UnitType.infantry => tr('infantry_card_description'),
      UnitType.cavalry => tr('cavalry_card_description'),
      UnitType.machineGunnersCart => tr('machine_gunners_cart_card_description'),
      UnitType.machineGuns => tr('machine_gunners_card_description'),
      UnitType.tank => tr('tank_card_description'),
      UnitType.destroyer => tr('destroyer_card_description'),
      UnitType.cruiser => tr('cruiser_card_description'),
      UnitType.battleship => tr('battleship_card_description'),
      UnitType.carrier => tr('carrier_card_description'),
    };

    if (_collapsed) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Text(
          text,
          style: AppTypography.s18w400,
        ),
      );
    }
  }

  String _getPhoto(UnitType type) {
    final photo = switch (type) {
      UnitType.armoredCar => 'photo_armored_car.webp',
      UnitType.artillery => 'photo_artillery.webp',
      UnitType.infantry => 'photo_infantry.webp',
      UnitType.cavalry => 'photo_cavalry.webp',
      UnitType.machineGunnersCart => 'photo_machine_gunners_cart.webp',
      UnitType.machineGuns => 'photo_machine_gunners.webp',
      UnitType.tank => 'photo_tank.webp',
      UnitType.destroyer => 'photo_destroyer.webp',
      UnitType.cruiser => 'photo_cruiser.webp',
      UnitType.battleship => 'photo_battleship.webp',
      UnitType.carrier => 'photo_carrier.webp',
    };

    return '$_unitsPath$photo';
  }
}
