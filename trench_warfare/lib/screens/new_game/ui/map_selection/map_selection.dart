part of map_selection_ui;

class MapSelection extends StatefulWidget {
  const MapSelection({super.key});

  @override
  State<StatefulWidget> createState() => _MapSelectionState();
}

class _MapSelectionState extends State<MapSelection> with ImageLoading {
  bool _isBackgroundLoaded = false;

  late final MapSelectionViewModel _viewModel;

  late final ui.Image _oldBookCover;
  late final ui.Image _oldPaper;

  @override
  void initState() {
    super.initState();

    _viewModel = MapSelectionViewModel();
    _init();
  }

  Future<void> _init() async {
    _oldBookCover = await loadImage('assets/images/screens/shared/old_book_cover.webp');
    _oldPaper = await loadImage('assets/images/screens/shared/old_paper.webp', completeCallback: () {
      setState(() {
        _isBackgroundLoaded = true;
      });
    });

    await _viewModel.init();
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

    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        StreamBuilder<MapSelectionState>(
          stream: _viewModel.gameFieldState,
          builder: (context, value) {
            if (!value.hasData) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(7, 36, 7, 36),
              child: Background.image(
                image: _oldBookCover,
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    MapSelectionBookmarks(
                      state: value.data as MapSelectionState,
                      onSwitchTab: (selectedTab) {
                        // setState(() {
                        //   _selectedTab = selectedTab;
                        // });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                      child: Background.image(
                        image: _oldPaper,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          alignment: AlignmentDirectional.topCenter,
                          child: SizedBox.shrink(),/*CardsList(
                            key: ObjectKey(_selectedTab),
                            factory: _getCardsFactory(_selectedTab),
                            onCardSelected: (index) => _selectedCardIndex = index,
                          ),*/
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
/*
        StreamBuilder<MapSelectionState>(
          stream: _viewModel.gameFieldState,
          builder: (context, value) {
            return switch (value.data.runtimeType) {
              Loading() => Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'Loading',
                      style: AppTypography.s20w600,
                    ),
                  ),
                ),
              MapSelectionState() => Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'Cards',
                      style: AppTypography.s20w600,
                    ),
                  ),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
*/
        CornerButton(
          left: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_select.webp'),
          onPress: () {
            Navigator.of(context)
                .pushNamed(Routes.gameField, arguments: 'test/7x7_win_defeat_conditions.tmx');
          },
        ),
        // Close button
        CornerButton(
          right: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_close.webp'),
          onPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
