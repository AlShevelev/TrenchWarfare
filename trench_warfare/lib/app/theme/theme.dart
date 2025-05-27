
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

import 'typography.dart';
import 'colors.dart';

class AppThemeFactory {
  static ThemeData defaultTheme() {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.white,
        onPrimary: AppColors.ginger,
        secondary: AppColors.ginger,
        onSecondary: AppColors.white,
        error: AppColors.red,
        onError: AppColors.white,
        background: AppColors.white,
        onBackground: AppColors.ginger,
        surface: AppColors.white,
        onSurface: AppColors.ginger
      ),

      scaffoldBackgroundColor: AppColors.white,

/*
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBrown,
        shadowColor: AppColors.lightBrown,
        elevation: 0,
        centerTitle: true,
        actionsIconTheme: IconThemeData(
            color: AppColors.black
        ),
        iconTheme: IconThemeData(
          color: AppColors.black
        )
      ),
*/

      fontFamily: 'Lemon',

      textTheme: const TextTheme(
        headlineLarge: AppTypography.s24w400,
        headlineMedium: AppTypography.s24w400,
        headlineSmall: AppTypography.s24w400,

        titleLarge: AppTypography.s14w400,
        titleMedium: AppTypography.s14w400,

        bodyLarge: AppTypography.s14w400,
        bodyMedium: AppTypography.s14w400,
      )
    );
  }
}