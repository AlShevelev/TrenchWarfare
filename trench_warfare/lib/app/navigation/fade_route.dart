/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of navigation;

class _FadeRoute extends PageRouteBuilder {
  _FadeRoute(Widget page)
      : super(
          pageBuilder: _createBuilder(page),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: _createTransition(),
        );

  static RoutePageBuilder _createBuilder(Widget page) {
    return (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page;
  }

  static RouteTransitionsBuilder _createTransition() {
    return (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
        FadeTransition(
          opacity: animation,
          child: child,
        );
  }
}
