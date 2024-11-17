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
    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_slot.selected) {
              _userActions.onCardClick(_slot.slotId);
            }
          },
          child: Cardboard(
              selected: _slot.selected,
              style: CardboardStyle.red,
              child: const SizedBox(height: 50,)
          ),
        ),
      ),
    );
  }
}
