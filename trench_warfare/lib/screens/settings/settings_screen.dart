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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Background(
          imagePath: 'assets/images/screens/shared/screen_background.webp',
          child: Settings(
            onClose: (result) {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
