part of save_load_screen;

class SaveLoadScreen extends StatelessWidget {
  const SaveLoadScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Background.path(
        imagePath: 'assets/images/screens/shared/screen_background.webp',
        child: const _SlotSelection(isSave: true),
      ),
    );
  }
}
// screen and navigation from the start page
// pass cancel/back and accept action (with selected slot index) to _SlotSelection
