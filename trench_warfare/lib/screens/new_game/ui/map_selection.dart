import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:trench_warfare/app/navigation/routes.dart';
import 'package:trench_warfare/core_entities/localization/app_locale.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:trench_warfare/screens/new_game/view_model/map_selection_view_model.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';

class MapSelection extends StatefulWidget {
  const MapSelection({super.key});

  @override
  State<StatefulWidget> createState() => _MapSelectionState();
}

class _MapSelectionState extends State<MapSelection> {
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
    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        StreamBuilder<MapSelectionState>(stream: _viewModel.gameFieldState, builder: (context, value) {
          switch (value.data.runtimeType) {
            case Loading: {
              return SizedBox.shrink();
            }
            case MapSelectionState: {
              return SizedBox.shrink();
            }
            default: {
              return const SizedBox.shrink();
            }
          }
        }),
        CornerButton(
          left: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_select.webp'),
          onPress: () {
            Navigator.of(context).pushNamed(Routes.gameField, arguments: 'test/7x7_win_defeat_conditions.tmx'/*'real/europe/the_battle_of_tannenburg.tmx'*/);
          },
        ),
        // Close button
        CornerButton(
          right: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_close.webp'),
          onPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
