part of card_controls;

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

  CardsTab _selectedTab = CardsTab.units;
  int _selectedCardIndex = -1;

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
                  CardsBookmarks(
                    onSwitchTab: (selectedTab) {
                      setState(() {
                        _selectedTab = selectedTab;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                    child: Background.image(
                      image: _oldPaper,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        alignment: AlignmentDirectional.topCenter,
                        child: CardsList(
                          key: ObjectKey(_selectedTab),
                          factory: _getCardsFactory(_selectedTab),
                          onCardSelected: (index) =>  _selectedCardIndex = index,
                        ),
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
            onPress: () {
              if (_selectedCardIndex != -1) {
                switch(_selectedTab) {
                  case CardsTab.units: { widget._gameField.onCardSelected(widget.state.units[_selectedCardIndex]); }
                  case CardsTab.productionCenters: { widget._gameField.onCardSelected(widget.state.productionCenters[_selectedCardIndex]); }
                  case CardsTab.terrainModifiers: { widget._gameField.onCardSelected(widget.state.terrainModifiers[_selectedCardIndex]); }
                  case CardsTab.unitBoosters: { widget._gameField.onCardSelected(widget.state.unitBoosters[_selectedCardIndex]); }
                  case CardsTab.specialStrikes: { widget._gameField.onCardSelected(widget.state.specialStrikes[_selectedCardIndex]); }
                }
              } else {
                widget._gameField.onCardSelected(null);
              }
            },
          ),
          // Close button
          GameFieldCornerButton(
            right: 15,
            bottom: 15,
            image: const AssetImage('assets/images/game_field_overlays/cards/button_close.webp'),
            onPress: () {
              widget._gameField.onCardsClosed();
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
  }

  CardsFactory<GameFieldControlsCard> _getCardsFactory(CardsTab tab) => switch (tab) {
        // ignore: unnecessary_cast
        CardsTab.units => UnitsCardFactory(widget.state.units) as CardsFactory<GameFieldControlsCard>,
        CardsTab.productionCenters => ProductionCentersCardFactory(widget.state.productionCenters),
        CardsTab.terrainModifiers => TerrainModifiersCardFactory(widget.state.terrainModifiers),
        CardsTab.unitBoosters => UnitBoosterCardFactory(widget.state.unitBoosters),
        CardsTab.specialStrikes => SpecialStrikesCardFactory(widget.state.specialStrikes),
      };
}
