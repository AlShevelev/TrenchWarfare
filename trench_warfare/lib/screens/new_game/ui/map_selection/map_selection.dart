part of map_selection_ui;

class MapSelection extends StatefulWidget {
  const MapSelection({super.key});

  @override
  State<StatefulWidget> createState() => _MapSelectionState();
}

class _MapSelectionState extends State<MapSelection> with ImageLoading {
  late final MapSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = MapSelectionViewModel();

    _init();
  }

  Future<void> _init() async {
    await _viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Background(
                      imagePath: 'assets/images/screens/shared/old_book_cover.webp',
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          _Bookmarks(
                            activeTab: value.data!.selectedTab.code,
                            isLoading: value.data is Loading,
                            userActions: _viewModel,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                            child: Background(
                              imagePath: 'assets/images/screens/shared/old_paper.webp',
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                alignment: AlignmentDirectional.topCenter,
                                child: _MapsList(
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
                        .pushNamed(Routes.fromMapSelectionToGameFieldNewGame, arguments: _viewModel.getNavigateToGameFieldArguments());
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
