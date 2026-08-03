/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
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
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: Column(
          children: [
            if (isBottom)
              const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 55.0,
                ),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/screens/tutorial/tutorial_card.webp'),
                    fit: BoxFit.fill,
                    centerSlice: Rect.fromLTWH(27, 27, 407, 170),
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
            if (!isBottom)
              const Spacer(),
          ],
        ),
      ),
    );
  }
}
