import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/app/theme/colors.dart';

enum CardboardStyle {
  red,
  green,
  blue,
  yellow,
  brown,
}

class Cardboard extends StatelessWidget {
  final Widget? child;

  final bool selected;

  final CardboardStyle style;

  const Cardboard({
    super.key,
    this.child,
    this.selected = false,
    this.style = CardboardStyle.red,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/screens/shared/card_background.webp'),
            fit: BoxFit.fill,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: _getBorderColor(), width: 4),
          boxShadow: [
            BoxShadow(
              color: selected ? AppColors.black : AppColors.halfDark,
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: child,
      );

  Color _getBorderColor() => switch (style) {
    CardboardStyle.red => AppColors.darkRed,
    CardboardStyle.green => AppColors.darkGreen,
    CardboardStyle.blue => AppColors.darkBlue,
    CardboardStyle.yellow => AppColors.darkYellow,
    CardboardStyle.brown => AppColors.darkBrown,
  };
}
