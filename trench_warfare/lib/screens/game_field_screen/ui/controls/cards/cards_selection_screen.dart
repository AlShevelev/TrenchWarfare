/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

class CardsSelectionScreen extends StatefulWidget {
  final CardsSelectionControls state;

  final GameFieldForControls _gameField;

  final Nation _nation;

  const CardsSelectionScreen({
    required this.state,
    required GameFieldForControls gameField,
    required Nation nation,
    super.key,
  })  : _gameField = gameField,
        _nation = nation;

  @override
  State<CardsSelectionScreen> createState() => _CardsSelectionScreenState();
}

class _CardsSelectionScreenState extends State<CardsSelectionScreen> with ImageLoading {
  late final _CardsSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = _CardsSelectionViewModel(widget.state, widget._gameField.gameFieldId);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_CardsScreenState>(
      stream: _viewModel.cardsState,
      builder: (context, value) {
        if (!value.hasData) {
          return const SizedBox.shrink();
        }

        final state = value.data as _DataIsReady;
        final selectedTab = state.selectedTab;

        return Background(
          imagePath: 'assets/images/screens/shared/screen_background.webp',
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 36, 7, 36),
                child: Background(
                  imagePath: 'assets/images/screens/shared/old_book_cover.webp',
                  child: Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      _CardsBookmarks(
                        tabs: state.tabs,
                        userActions: _viewModel,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                        child: Background(
                          imagePath: 'assets/images/screens/shared/old_paper.webp',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            alignment: AlignmentDirectional.topCenter,
                            child: _CardsList(
                              key: ObjectKey(selectedTab),
                              factory: _getCardsFactory(selectedTab),
                              tabCode: selectedTab.code,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Select button
              CornerButton(
                left: 15,
                bottom: 15,
                image: const AssetImage('assets/images/screens/shared/button_select.webp'),
                onPress: () {
                  if (state.isConfirmButtonEnabled) {
                    widget._gameField.onCardSelected(_viewModel.getSelectedCard());
                  }
                },
              ),
              // Close button
              CornerButton(
                right: 15,
                bottom: 15,
                image: const AssetImage('assets/images/screens/shared/button_close.webp'),
                onPress: () {
                  if (state.isCloseActionEnabled) {
                    widget._gameField.onCancelled();
                  }
                },
              ),
              GameFieldGeneralPanel(
                money: widget.state.totalMoney,
                nation: widget._nation,
                left: 15,
                top: 0,
              ),
            ],
          ),
        );
      },
    );
  }

  _CardsFactory _getCardsFactory(_TabDto tab) => switch (tab.code) {
        _TabCode.units => _UnitsCardFactory(
            tab.cards as List<_CardDto<UnitType>>,
            _viewModel,
          ) as _CardsFactory,
        _TabCode.productionCenters => _ProductionCentersCardFactory(
            tab.cards as List<_CardDto<ProductionCenterType>>,
            _viewModel,
          ),
        _TabCode.terrainModifiers => _TerrainModifiersCardFactory(
            tab.cards as List<_CardDto<TerrainModifierType>>,
            _viewModel,
          ),
        _TabCode.unitBoosters => _UnitBoosterCardFactory(
            tab.cards as List<_CardDto<UnitBoost>>,
            _viewModel,
          ),
        _TabCode.specialStrikes => _SpecialStrikesCardFactory(
            tab.cards as List<_CardDto<SpecialStrikeType>>,
            _viewModel,
          ),
      };
}
