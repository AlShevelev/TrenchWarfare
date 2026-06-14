import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/screens/tutorials/ui/controls/tutorial_ui_calculator.dart';
import 'package:easy_localization/easy_localization.dart' as localization;

class TutorialInfoPanel extends StatelessWidget {
  final bool isBottom;

  final String textLocaleCode;

  final Function onPress;

  const TutorialInfoPanel({
    super.key,
    required this.isBottom,
    required this.textLocaleCode,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final rect = TutorialUiCalculator.getInfoPanel(screenSize, isBottom: isBottom);

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () {
            onPress();
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/screens/tutorial/tutorial_card.webp'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                localization.tr(textLocaleCode),
                textAlign: TextAlign.start,
                softWrap: true,
                style: AppTypography.s15w400.copyWith(color: AppColors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
