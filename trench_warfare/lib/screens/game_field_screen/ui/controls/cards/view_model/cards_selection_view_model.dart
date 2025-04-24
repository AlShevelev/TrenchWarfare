part of card_controls;

class _CardsSelectionViewModel extends ViewModelBase implements _CardsSelectionUserActions {
  static _TabCode? _lastSelectedTab;

  static int? _lastGameFieldId;

  final SingleStream<_CardsScreenState> _cardsState = SingleStream<_CardsScreenState>();

  Stream<_CardsScreenState> get cardsState => _cardsState.output;

  _CardsSelectionViewModel(
    CardsSelectionControls state,
    int gameFieldId,
  ) {
    if (_lastGameFieldId != gameFieldId) {
      _lastGameFieldId = gameFieldId;
      _lastSelectedTab = _TabCode.units;
    }

    _cardsState.update(_DataIsReady(tabs: [
      state.units.let<_TabDto<UnitType>>((cards) {
        final firstSelectedIndex = _getFirstSelectedIndex(cards);

        return _TabDto<UnitType>(
          code: _TabCode.units,
          selected: _lastSelectedTab == _TabCode.units,
          cards: cards
              .mapIndexed((i, c) => _CardDto<UnitType>(
                    indexInTab: i,
                    selected: i == firstSelectedIndex,
                    expanded: false,
                    canBuild: _canBuild(c),
                    card: c,
                  ))
              .toList(growable: false),
        );
      })!,
      state.productionCenters.let<_TabDto<ProductionCenterType>>((cards) {
        final firstSelectedIndex = _getFirstSelectedIndex(cards);

        return _TabDto<ProductionCenterType>(
          code: _TabCode.productionCenters,
          selected: _lastSelectedTab == _TabCode.productionCenters,
          cards: cards
              .mapIndexed((i, c) => _CardDto<ProductionCenterType>(
                    indexInTab: i,
                    selected: i == firstSelectedIndex,
                    expanded: false,
                    canBuild: _canBuild(c),
                    card: c,
                  ))
              .toList(growable: false),
        );
      })!,
      state.terrainModifiers.let<_TabDto<TerrainModifierType>>((cards) {
        final firstSelectedIndex = _getFirstSelectedIndex(cards);

        return _TabDto<TerrainModifierType>(
          code: _TabCode.terrainModifiers,
          selected: _lastSelectedTab == _TabCode.terrainModifiers,
          cards: cards
              .mapIndexed((i, c) => _CardDto<TerrainModifierType>(
                    indexInTab: i,
                    selected: i == firstSelectedIndex,
                    expanded: false,
                    canBuild: _canBuild(c),
                    card: c,
                  ))
              .toList(growable: false),
        );
      })!,
      state.unitBoosters.let<_TabDto<UnitBoost>>((cards) {
        final firstSelectedIndex = _getFirstSelectedIndex(cards);

        return _TabDto<UnitBoost>(
          code: _TabCode.unitBoosters,
          selected: _lastSelectedTab == _TabCode.unitBoosters,
          cards: cards
              .mapIndexed((i, c) => _CardDto<UnitBoost>(
                    indexInTab: i,
                    selected: i == firstSelectedIndex,
                    expanded: false,
                    canBuild: _canBuild(c),
                    card: c,
                  ))
              .toList(growable: false),
        );
      })!,
      state.specialStrikes.let<_TabDto<SpecialStrikeType>>((cards) {
        final firstSelectedIndex = _getFirstSelectedIndex(cards);

        return _TabDto<SpecialStrikeType>(
          code: _TabCode.specialStrikes,
          selected: _lastSelectedTab == _TabCode.specialStrikes,
          cards: cards
              .mapIndexed((i, c) => _CardDto<SpecialStrikeType>(
                    indexInTab: i,
                    selected: i == firstSelectedIndex,
                    expanded: false,
                    canBuild: _canBuild(c),
                    card: c,
                  ))
              .toList(growable: false),
        );
      })!,
    ]));
  }

  @override
  void dispose() {
    _cardsState.close();
  }

  int _getFirstSelectedIndex(List<BuildPossibility> cards) =>
      cards.indexWhere((i) => i.buildError == null && i.canBuildByIndustryPoint && i.canBuildByCurrency);

  bool _canBuild(BuildPossibility buildPossibility) =>
      buildPossibility.buildError == null &&
      buildPossibility.canBuildByIndustryPoint &&
      buildPossibility.canBuildByCurrency;

  void _updateState(void Function(_DataIsReady) action) {
    final state = _cardsState.current;

    if (state is _DataIsReady) {
      action(state);

      final newState = state.copy(state.tabs);
      _cardsState.update(newState);
    }
  }

  @override
  void onCardExpendedOrCollapsed(int indexInTab) => _updateState((oldState) {
        final selectedTab = oldState.selectedTab;
        final card = selectedTab.cards.singleWhere((c) => c.indexInTab == indexInTab);
        card.setExpended(!card.expanded);
      });

  @override
  void onCardSelected(int indexInTab) => _updateState((oldState) {
        final selectedTab = oldState.selectedTab;
        for (var card in selectedTab.cards) {
          card.setSelected(card.indexInTab == indexInTab);
        }
      });

  @override
  void onTabSelected(_TabCode tabCode) {
    _lastSelectedTab = tabCode;

    _updateState((oldState) {
      for (var tab in oldState.tabs) {
        tab.setSelected(tab.code == tabCode);
      }
    });
  }

  GameFieldControlsCard? getSelectedCard() {
    final state = _cardsState.current;

    if (state is _DataIsReady) {
      return state.selectedTab.cards.firstWhereOrNull((c) => c.selected)?.card;
    }

    return null;
  }
}
