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

class _EmptyCard extends StatelessWidget {
  final _EmptySlotDto _slot;

  final _SaveLoadUserActions _userActions;

  const _EmptyCard({
    super.key,
    required _EmptySlotDto slot,
    required _SaveLoadUserActions userActions,
  })  : _slot = slot,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_slot.selected) {
              audioController.playSound(SoundType.buttonClick);
              _userActions.onCardClick(_slot.slotNumber);
            }
          },
          child: Cardboard(
              selected: _slot.selected,
              style: CardboardStyle.red,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    localization.tr('save_load_empty_slot'),
                    style: AppTypography.s20w600,
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}
