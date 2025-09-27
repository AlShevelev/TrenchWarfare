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

class SettingsCheckbox extends StatefulWidget {
  final void Function(bool) _onValueChanged;

  final bool _startValue;

  final String _title;

  final ImageProvider _checkedIcon;
  final ImageProvider _uncheckedIcon;

  const SettingsCheckbox({
    super.key,
    required bool startValue,
    required String title,
    required ImageProvider checkedIcon,
    required ImageProvider uncheckedIcon,
    required void Function(bool) onValueChanged,
  })  : _startValue = startValue,
        _onValueChanged = onValueChanged,
        _title = title,
        _checkedIcon = checkedIcon,
        _uncheckedIcon = uncheckedIcon;

  @override
  State<StatefulWidget> createState() => _SettingsCheckboxState();
}

class _SettingsCheckboxState extends State<SettingsCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget._startValue;
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 30.0;

    return GestureDetector(
      onTap: () {
        final newValue = !_value;

        setState(() {
          widget._onValueChanged(newValue);
          _value = newValue;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.start,
            widget._title,
            style: AppTypography.s20w600,
          ),
          Image(
            image: _value ? widget._checkedIcon : widget._uncheckedIcon,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
