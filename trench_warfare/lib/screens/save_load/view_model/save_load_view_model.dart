part of save_load_screen;

class _SaveLoadViewModel extends ViewModelBase implements _SaveLoadUserActions {
  final bool _isSave;

  final SingleStream<_SaveLoadScreenState> _state = SingleStream<_SaveLoadScreenState>();
  Stream<_SaveLoadScreenState> get state => _state.output;

  int? get selectedSlotId => state is _Loading
      ? null
      : ((state as _DataIsLoaded).slots.firstWhereOrNull((s) => s.selected))?.slotNumber;

  _SaveLoadViewModel({required bool isSave}) : _isSave = isSave {
    _state.update(_Loading());
  }

  Future<void> init() async {
    // Fake implementation vvvvvvvvvvvvv
    await Future.delayed(const Duration(seconds: 1));

    if (_isSave) {
      // Add empty slots here (up to 10 slots total)
      final slots = [
        _DataSlotDto(
          selected: false,
          slotNumber: 0,
          isAutosave: true,
          title: 'Battle of Tannenberg',
          day: 42,
          saveDateTime: DateTime.now(),
          sideOfConflict: [
            _SideOfConflictDto(nation: Nation.russia, selected: false),
            _SideOfConflictDto(nation: Nation.germany, selected: true),
          ],
        ),
        _DataSlotDto(
          selected: false,
          slotNumber: 1,
          isAutosave: false,
          title: 'Russia-Japanese war',
          day: 142,
          saveDateTime: DateTime.now(),
          sideOfConflict: [
            _SideOfConflictDto(nation: Nation.japan, selected: true),
            _SideOfConflictDto(nation: Nation.russia, selected: false),
          ],
        ),
        _EmptySlotDto(selected: false, slotNumber: 2),
        _EmptySlotDto(selected: false, slotNumber: 3),
        _EmptySlotDto(selected: false, slotNumber: 4),
        _EmptySlotDto(selected: false, slotNumber: 5),
        _EmptySlotDto(selected: false, slotNumber: 6),
        _EmptySlotDto(selected: false, slotNumber: 7),
        _EmptySlotDto(selected: false, slotNumber: 8),
        _EmptySlotDto(selected: false, slotNumber: 9),
      ];
      _state.update(_DataIsLoaded(slots: slots));
    } else {
      final slots = [
        _DataSlotDto(
          selected: false,
          slotNumber: 0,
          isAutosave: true,
          title: 'Battle of Tannenberg',
          day: 42,
          saveDateTime: DateTime.now(),
          sideOfConflict: [
            _SideOfConflictDto(nation: Nation.russia, selected: false),
            _SideOfConflictDto(nation: Nation.germany, selected: true),
          ],
        ),
        _DataSlotDto(
          selected: false,
          slotNumber: 2,
          isAutosave: false,
          title: 'Russia-Japanese war',
          day: 142,
          saveDateTime: DateTime.now(),
          sideOfConflict: [
            _SideOfConflictDto(nation: Nation.japan, selected: true),
            _SideOfConflictDto(nation: Nation.russia, selected: false),
          ],
        ),
      ];
      _state.update(_DataIsLoaded(slots: slots));
    }
    // Fake implementation ^^^^^^^^^^^^
  }

  @override
  void onCardClick(int slotIndex) => _updateState((oldState) {
        for (var slot in oldState.slots) {
          slot.setSelected(selected: slot.slotNumber == slotIndex);
        }
      });

  @override
  void dispose() {
    _state.close();
  }

  void _updateState(void Function(_DataIsLoaded) action) {
    final state = _state.current;

    if (state is _DataIsLoaded) {
      action(state);

      final newState = state.copy(state.slots);
      _state.update(newState);
    }
  }
}
