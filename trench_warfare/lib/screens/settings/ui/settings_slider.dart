part of settings;

class SettingsSlider extends StatefulWidget {
  final void Function(double) _onValueChanged;

  final double _minValue;
  final double _maxValue;
  final double _startValue;

  final String _title;

  final ImageProvider _leftIcon;
  final ImageProvider _rightIcon;

  const SettingsSlider({
    super.key,
    required double minValue,
    required double maxValue,
    required double startValue,
    required String title,
    required ImageProvider leftIcon,
    required ImageProvider rightIcon,
    required void Function(double) onValueChanged,
  })  : _minValue = minValue,
        _maxValue = maxValue,
        _startValue = startValue,
        _onValueChanged = onValueChanged,
        _title = title,
        _leftIcon = leftIcon,
        _rightIcon = rightIcon;

  @override
  State<StatefulWidget> createState() => _SettingsSliderState();
}

class _SettingsSliderState extends State<SettingsSlider> {
  double _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget._startValue;
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 35.0;

    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          widget._title,
          style: AppTypography.s22w600,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image(
              image: widget._leftIcon,
              width: iconSize,
            ),
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 5,
                  activeTrackColor: AppColors.black,
                  inactiveTrackColor: AppColors.black,
                  thumbColor: AppColors.black,
                  overlayColor: Colors.transparent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                ),
                child: Slider(
                  min: widget._minValue.toDouble(),
                  max: widget._maxValue.toDouble(),
                  value: _value.toDouble(),
                  onChanged: (val) {
                    _value = val;
                    setState(() {});
                  },
                  onChangeEnd: (val) {
                    widget._onValueChanged(val);
                  },
                ),
              ),
            ),
            Image(
              image: widget._rightIcon,
              width: iconSize,
            ),
          ],
        ),
      ],
    );
  }
}
