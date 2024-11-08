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

    return StreamBuilder<MapSelectionState>(
        stream: _viewModel.gameFieldState,
        builder: (context, value) {
          return PopScope(
            canPop: value.hasData && value.data is! Loading,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (!value.hasData)
                  const SizedBox.shrink()
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 20, 7, 20),
                    child: Background.image(
                      image: _oldBookCover,
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Bookmarks(
                            activeTab: value.data!.selectedTab.code,
                            isLoading: value.data is Loading,
                            userActions: _viewModel,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                            child: Background.image(
                              image: _oldPaper,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                alignment: AlignmentDirectional.topCenter,
                                child: MapsList(
                                  cards: value.data is Loading
                                      ? null
                                      : (value.data as DataIsReady).selectedTab.cards,
                                  selectedTab: value.data!.selectedTab.code,
                                  userActions: _viewModel,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                CornerButton(
                  left: 15,
                  bottom: 15,
                  image: const AssetImage('assets/images/screens/shared/button_select.webp'),
                  enabled: value.data?.isConfirmButtonEnabled ?? false,
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
                  enabled: value.data?.isCloseActionEnabled ?? false,
                  onPress: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
