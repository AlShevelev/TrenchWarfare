/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of save_load_screen;

class _SaveLoadViewModel extends ViewModelBase implements _SaveLoadUserActions {
  final bool isSave;

  final SingleStream<_SaveLoadScreenState> _state = SingleStream<_SaveLoadScreenState>();
  Stream<_SaveLoadScreenState> get state => _state.output;

  GameSlot? get selectedSlot => _state.current is _Loading
      ? null
      : ((_state.current as _DataIsLoaded).slots.firstWhereOrNull((s) => s.selected))?.slotNumber;

  String? get selectedMapFileName {
    if (_state.current is _Loading) {
      return null;
    }

    final dataState = _state.current as _DataIsLoaded;
    final selectedSlot = dataState.slots.firstWhereOrNull((s) => s.selected);

    if (selectedSlot is _DataSlotDto) {
      return selectedSlot.mapFileName;
    }

    return null;
  }

  late final _dao = Database.saveLoadGameDao;

  _SaveLoadViewModel({required this.isSave}) {
    _state.update(_Loading());
  }

  Future<void> init() async {
    final allDbSlots = _dao.readAllSlots();

    final slots = <_SlotDto>[];

    if (isSave) {
      for (var i = GameSlot.slot0.index; i <= GameSlot.slot9.index; i++) {
        final dbSlotCandidate = allDbSlots.firstWhereOrNull((s) => s.slotNumber == i);

        // Some slots may be skipped
        if (dbSlotCandidate == null) {
          slots.add(_EmptySlotDto(selected: false, slotNumber: GameSlot.createFromIndex(i)));
        } else {
          slots.add(await _mapSlotDbToDto(dbSlotCandidate));
        }
      }
    } else {
      for (final dbSlot in allDbSlots) {
        slots.add(await _mapSlotDbToDto(dbSlot));
      }
    }

    _state.update(_DataIsLoaded(slots: slots));
  }

  @override
  void onCardClick(GameSlot cardSlot) {
    // We can't select a slot for auto-save for saving
    if (isSave && cardSlot == GameSlot.autoSave) {
      return;
    }

    _updateState((oldState) {
      for (var slot in oldState.slots) {
        slot.setSelected(selected: slot.slotNumber == cardSlot);
      }
    });
  }

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

  Future<_DataSlotDto> _mapSlotDbToDto(SaveSlotDbEntity slotDbEntity) async {
    final nations = _dao.readAllNations(slotDbEntity.dbId);

    final metadataRecord = (await MapDecoder.openFile(slotDbEntity.mapFileName)).getMetadata();

    final slotNumber = GameSlot.createFromIndex(slotDbEntity.slotNumber);

    return _DataSlotDto(
      selected: slotNumber == GameSlot.autoSave && !isSave,
      slotNumber: slotNumber,
      isAutosave: slotDbEntity.isAutosave,
      title: metadataRecord!.title,
      day: nations.firstWhere((n) => n.isHuman).day,
      saveDateTime: slotDbEntity.saveDateTime,
      sideOfConflict: nations.map((n) => _SideOfConflictDto(
            nation: Nation.createFromIndex(n.nation),
            selected: n.isHuman,
          )),
      mapFileName: slotDbEntity.mapFileName,
    );
  }
}
