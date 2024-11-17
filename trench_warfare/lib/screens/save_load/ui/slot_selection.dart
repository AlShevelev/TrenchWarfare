part of save_load_screen;

class _SlotSelection extends StatefulWidget {
  final bool _isSave;

  const _SlotSelection({super.key, required bool isSave}) : _isSave = isSave;

  @override
  State<StatefulWidget> createState() => _SlotSelectionState();
}

class _SlotSelectionState extends State<_SlotSelection> with ImageLoading {
  bool _isBackgroundLoaded = false;

  late final _SaveLoadViewModel _viewModel;

  late final ui.Image _oldBookCover;
  late final ui.Image _oldPaper;

  @override
  void initState() {
    super.initState();

    _viewModel = _SaveLoadViewModel(isSave: widget._isSave);

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

    return StreamBuilder<_SaveLoadScreenState>(
        stream: _viewModel.state,
        builder: (context, value) {
          return PopScope(
            canPop: value.hasData && value.data is! _Loading,
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
                          _Bookmarks(isSave: widget._isSave),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                            child: Background.image(
                              image: _oldPaper,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                alignment: AlignmentDirectional.topCenter,
                                child: _getList(value.data),
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
                    // Navigator.of(context)
                    //     .pushNamed(Routes.gameField, arguments: _viewModel.getNavigateToGameFieldArguments());
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

  Widget _getList(_SaveLoadScreenState? state) {
    if (state == null || state is _Loading) {
      return _getStateText(tr('loading'));
    }

    final slots = (state as _DataIsLoaded).slots;

    if (slots.isEmpty) {
      return _getStateText(tr('save_load_empty_load'));
    }

    return ListView.builder(
        itemCount: slots.length,
        itemBuilder: (context, index) {
          final slot = slots.elementAt(index);

          if (slot is _EmptySlotDto) {
            return _EmptyCard(slot: slot, userActions: _viewModel);
          }

          return _DataCard(slot: slot as _DataSlotDto, userActions: _viewModel);
        });
  }

  Widget _getStateText(String text) {
    return Center(
      child: DefaultTextStyle(
        style: AppTypography.s20w600,
        child: Text(text),
      ),
    );
  }
}
