part of card_controls;

class CardsSelectionScreen extends StatefulWidget {
  final CardsSelectionControls state;

  late final GameFieldForControls _gameField;

  CardsSelectionScreen({required this.state, required GameFieldForControls gameField, super.key}) {
    _gameField = gameField;
  }

  @override
  State<CardsSelectionScreen> createState() => _CardsSelectionScreenState();
}

class _CardsSelectionScreenState extends State<CardsSelectionScreen> with ImageLoading {
  bool _isBackgroundLoaded = false;

  late final ui.Image _background;
  late final ui.Image _oldBookCover;
  late final ui.Image _oldPaper;

  late final _CardsSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = _CardsSelectionViewModel(widget.state);

    init();
  }

  Future init() async {
    _background = await loadImage('assets/images/screens/shared/screen_background.webp');
    _oldBookCover = await loadImage('assets/images/screens/shared/old_book_cover.webp');
    _oldPaper = await loadImage('assets/images/screens/shared/old_paper.webp', completeCallback: () {
      setState(() {
        _isBackgroundLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBackgroundLoaded) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<_CardsScreenState>(
      stream: _viewModel.cardsState,
      builder: (context, value) {
        if (!value.hasData) {
          return const SizedBox.shrink();
        }

        final state = value.data as _DataIsReady;
        final selectedTab = state.selectedTab;

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
                      _CardsBookmarks(
                        tabs: state.tabs,
                        userActions: _viewModel,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                        child: Background.image(
                          image: _oldPaper,
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
