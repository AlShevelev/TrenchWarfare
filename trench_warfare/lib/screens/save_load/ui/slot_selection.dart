part of save_load_screen;

class SlotSelection extends StatefulWidget {
  final bool _isSave;

  final void Function() _onCancel;

  /// The arguments are: 1) is an id of the selected slot; 2) the map's file name
  final void Function(GameSlot, String) _onSlotSelected;

  const SlotSelection({
    super.key,
    required bool isSave,
    required void Function() onCancel,
    required void Function(GameSlot, String) onSlotSelected,
  })  : _isSave = isSave,
        _onCancel = onCancel,
        _onSlotSelected = onSlotSelected;

  @override
  State<StatefulWidget> createState() => _SlotSelectionState();
}

class _SlotSelectionState extends State<SlotSelection> with ImageLoading {
  late final _SaveLoadViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = _SaveLoadViewModel(isSave: widget._isSave);

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
    return StreamBuilder<_SaveLoadScreenState>(
        stream: _viewModel.state,
        builder: (context, value) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (!didPop && value.hasData && value.data is! _Loading) {
                widget._onCancel();
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(7, 20, 7, 20),
                  child: Background(
                    imagePath: 'assets/images/screens/shared/old_book_cover.webp',
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        _Bookmarks(isSave: widget._isSave),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                          child: Background(
                            imagePath: 'assets/images/screens/shared/old_paper.webp',
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
                    final selectedSlot = _viewModel.selectedSlot;
                    final selectedMapFileName = _viewModel.selectedMapFileName;

                    if (selectedSlot != null) {
                      if (_viewModel.isSave) {
                        widget._onSlotSelected(selectedSlot, '');
                      } else {
                        if (selectedMapFileName != null) {
                          widget._onSlotSelected(selectedSlot, selectedMapFileName);
                        }
                      }
                    }
                  },
                ),
                // Close button
                CornerButton(
                  right: 15,
                  bottom: 15,
                  image: const AssetImage('assets/images/screens/shared/button_close.webp'),
                  enabled: value.data?.isCloseActionEnabled ?? false,
                  onPress: () {
                    widget._onCancel();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _getList(_SaveLoadScreenState? state) {
    if (state == null || state is _Loading) {
      return _getStateText(localization.tr('loading'));
    }

    final slots = (state as _DataIsLoaded).slots;

    if (slots.isEmpty) {
      return _getStateText(localization.tr('save_load_empty_load'));
    }

    return ListView.builder(
        itemCount: slots.length,
        itemBuilder: (context, index) {
          final slot = slots.elementAt(index);

          if (slot is _EmptySlotDto) {
            return _EmptyCard(slot: slot, userActions: _viewModel);
          }

          return _DataCard(
            slot: slot as _DataSlotDto,
            userActions: _viewModel,
            isSave: widget._isSave,
          );
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
