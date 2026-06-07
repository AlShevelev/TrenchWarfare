import 'dart:ui';

class TutorialUiCalculator {
  static Rect getAssistantRect(Size screenSize) {
    const sizeX = 112.0;
    const sizeY = 381.0;

    const offsetX = 5.0;
    const offsetY = 160.0;

    return Rect.fromLTWH(
      screenSize.width - offsetX - sizeX,
      screenSize.height - offsetY - sizeY,
      sizeX,
      sizeY,
    );
  }

  static Rect getInfoPanel(Size screenSize, {required bool isBottom}) {
    final bottomPanel = _getInfoPanelBottomRect(screenSize);
    if (isBottom) {
      return bottomPanel;
    } else {
      return Rect.fromLTWH(
        bottomPanel.left,
        5,
        bottomPanel.width,
        bottomPanel.height,
      );
    }
  }

  static Rect _getInfoPanelBottomRect(Size screenSize) {
    const verticalOffset = 5;

    final girlRect = getAssistantRect(screenSize);

    final top = girlRect.bottom + verticalOffset;
    final bottom = screenSize.height - verticalOffset;
    final height = bottom - top;
    final width = screenSize.width * 0.95;
    final left = (screenSize.width - width) / 2;

    return Rect.fromLTWH(left, top, width, height);
  }
}
