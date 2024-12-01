part of save_load_screen;

class _Bookmarks extends StatelessWidget {
  static const double _topPadding = 20;

  static const double _height = 83;

  static const double _startOffset = 40;

  final bool _isSave;

  const _Bookmarks({super.key, required bool isSave}) : _isSave = isSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_startOffset, _topPadding, 0, 0),
      child: Container(
        height: _height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/screens/shared/bookmarks/bookmark_red_68.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          child: StrokedText(
            text: localization.tr(_isSave ? 'save' : 'load'),
            style: AppTypography.s20w600,
            textColor: AppColors.white,
            strokeColor: AppColors.halfDark,
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }
}
