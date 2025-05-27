/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of settings;

class Settings extends StatefulWidget {
  final void Function(SettingsResult result) _onClose;

  const Settings({
    super.key,
    required void Function(SettingsResult result) onClose,
  }) : _onClose = onClose;

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with ImageLoading {
  late final _SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = _SettingsViewModel();

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
    final audioController = context.read<AudioController>();
    _viewModel.setAudioController(audioController);

    return StreamBuilder<_SettingsScreenState>(
        stream: _viewModel.uiState,
        builder: (context, value) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (!didPop && value.hasData && value.data is! _Loading) {
                widget._onClose(_viewModel.settingsValue);
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
                        const _Bookmark(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                          child: Background(
                            imagePath: 'assets/images/screens/shared/old_paper.webp',
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                              alignment: AlignmentDirectional.topCenter,
                              child: _getContent(value.data),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Close button
                CornerButton(
                  right: 15,
                  bottom: 15,
                  image: const AssetImage('assets/images/screens/shared/button_close.webp'),
                  enabled: value.data?.isCloseActionEnabled ?? false,
                  onPress: () {
                    widget._onClose(_viewModel.settingsValue);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _getContent(_SettingsScreenState? state) {
    if (state == null || state is _Loading) {
      return Center(
        child: DefaultTextStyle(
          style: AppTypography.s20w600,
          child: Text(localization.tr('loading')),
        ),
      );
    }

    const silentIcon = AssetImage('assets/images/screens/settings/icon_sound_off.webp');
    const loudIcon = AssetImage('assets/images/screens/settings/icon_sound_max.webp');
    const slowIcon = AssetImage('assets/images/screens/settings/icon_slow.webp');
    const fastIcon = AssetImage('assets/images/screens/settings/icon_fast.webp');

    const paddingBetween = 24.0;

    final dataState = state as _DataIsLoaded;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingBetween),
            child: SettingsSlider(
              minValue: dataState.minValue,
              maxValue: dataState.maxValue,
              startValue: dataState.music,
              title: localization.tr('settings_music'),
              leftIcon: silentIcon,
              rightIcon: loudIcon,
              onValueChanged: (value) => _viewModel.onMusicUpdated(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingBetween),
            child: SettingsSlider(
              minValue: dataState.minValue,
              maxValue: dataState.maxValue,
              startValue: dataState.sounds,
              title: localization.tr('settings_sounds'),
              leftIcon: silentIcon,
              rightIcon: loudIcon,
              onValueChanged: (value) => _viewModel.onSoundsUpdated(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingBetween),
            child: SettingsSlider(
              minValue: dataState.minValue,
              maxValue: dataState.maxValue,
              startValue: dataState.myUnitsSpeed,
              title: localization.tr('settings_my_units'),
              leftIcon: slowIcon,
              rightIcon: fastIcon,
              onValueChanged: (value) => _viewModel.onMyUnitsSpeedUpdated(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingBetween),
            child: SettingsSlider(
              minValue: dataState.minValue,
              maxValue: dataState.maxValue,
              startValue: dataState.enemyUnitsSpeed,
              title: localization.tr('settings_enemy_units'),
              leftIcon: slowIcon,
              rightIcon: fastIcon,
              onValueChanged: (value) => _viewModel.onEnemyUnitsSpeedUpdated(value),
            ),
          ),
        ],
      ),
    );
  }
}
