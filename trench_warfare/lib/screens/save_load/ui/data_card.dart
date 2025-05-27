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

class _DataCard extends StatelessWidget {
  final _DataSlotDto _slot;

  final _SaveLoadUserActions _userActions;

  final bool _isSave;

  const _DataCard({
    super.key,
    required _DataSlotDto slot,
    required _SaveLoadUserActions userActions,
    required bool isSave,
  })  : _slot = slot,
        _userActions = userActions,
        _isSave = isSave;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    final audioController = context.read<AudioController>();

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_slot.selected) {
              if (!(_slot.isAutosave && _isSave)) {
                audioController.playSound(SoundType.buttonClick);
              }

              _userActions.onCardClick(_slot.slotNumber);
            }
          },
          child: Cardboard(
            selected: _slot.selected,
            style: CardboardStyle.red,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                    child: Text(
                      textAlign: TextAlign.center,
                      _slot.title[locale] ?? '',
                      style: AppTypography.s20w600,
                    ),
                  ),
                  Text(
                    '${localization.tr('day')} ${_slot.day}',
                    style: AppTypography.s16w600,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: _Opponents(
                      opponents: _slot.sideOfConflict,
                    ),
                  ),
                  if (_slot.isAutosave)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        localization.tr('save_load_autosave'),
                        style: AppTypography.s20w600.copyWith(color: AppColors.darkRed),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: Row(
                        children: [
                          Text(
                            localization.DateFormat.Hm().format(_slot.saveDateTime),
                            style: AppTypography.s16w600..copyWith(color: AppColors.darkRed),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(
                            localization.DateFormat.yMMMMd().format(_slot.saveDateTime),
                            style: AppTypography.s16w600..copyWith(color: AppColors.darkRed),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
