part of card_controls;

typedef OnCardClick = void Function(int);

abstract class CardBase extends StatefulWidget {
  final ValueNotifier<bool> _selected = ValueNotifier(false);

  late final int index;

  late final OnCardClick _onClick;

  CardBase({
    super.key,
    required bool selected,
    required this.index,
    required OnCardClick onClick,
  }) {
    _selected.value = selected;
    _onClick = onClick;
  }

  void updateSelection(bool selected) => _selected.value = selected;
}

abstract class CardBaseState<T extends CardBase> extends State<T> {
  static const _imagesPath = 'assets/images/game_field_overlays/cards/';

  bool _collapsed = true;

  bool _selected = false;

  bool get canBuild {
    final buildPossibility = _getBuildPossibility();
    return buildPossibility.canBuildOnGameField && buildPossibility.canBuildByIndustryPoint && buildPossibility.canBuildByCurrency;
  }

  @override
  void initState() {
    super.initState();
    _selected = widget._selected.value;

    widget._selected.addListener(() {
      if (mounted) {
        setState(() {
          _selected = widget._selected.value;
        });
      }
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
            if (!_selected && canBuild) {
              widget._onClick(widget.index);
            }
          },
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getBackgroundImage()),
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
                        _getTitleText(),
                        style: AppTypography.s20w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Image.asset(_getPhoto()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: _getFeaturesPanel(),
                    ),
                    _getDescription(_getDescriptionText()),
                    _getFooter(_getFooterMoney(), _getFooterRestriction(), _getBuildPossibility()),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @protected
  String getBackgroundImage();

  @protected
  MoneyUnit _getFooterMoney();

  @protected
  BuildRestriction? _getFooterRestriction() => null;

  @protected
  BuildPossibility _getBuildPossibility();

  @protected
  Widget _getFooter(MoneyUnit money, BuildRestriction? restriction, BuildPossibility buildPossibility) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildRestrictionPanel(
          money: money,
          restriction: restriction,
          buildPossibility: buildPossibility,
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

  @protected
  Widget _getFeaturesPanel() => const SizedBox.shrink();

  @protected
  String _getTitleText();

  @protected
  String _getDescriptionText();

  Widget _getDescription(String text) {
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

  @protected
  String _getPhoto();
}
