/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flutter/widgets.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const Background({super.key, required this.child, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
        )
      ),
      constraints: const BoxConstraints.expand(),
      child: child,
    );
  }
}