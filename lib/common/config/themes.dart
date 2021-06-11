import 'package:flutter/material.dart';

enum Themes { light, dark, organizer }
ThemeData getThemeByType(Themes type) {
  switch (type) {
    case Themes.dark:
      return ThemeData(
        brightness: Brightness.dark,
      );
    case Themes.light:
      return ThemeData(
        brightness: Brightness.light,
      );
    case Themes.organizer:
      return ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: ThemeColor.orangeGradientStart,
        ),
        primaryColor: ThemeColor.orangeGradientEnd,
        cardColor: Colors.white,
        textTheme: TextTheme(),
      );
    default:
      return ThemeData(
        brightness: Brightness.light,
      );
  }
}

class ThemeColor {
  ///theme 1
  static const Color orangeGradientStart = const Color(0xFFfbab66);
  static const Color orangeGradientEnd = const Color(0xFFf7418c);

  static const orangeGradient = const LinearGradient(
    colors: const [orangeGradientStart, orangeGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  ///theme 2
  static const Color lightGradientStart = const Color(0xFFa1c4fd);
  static const Color lightGradientEnd = const Color(0xFFc2e9fb);

  static const lightGradient = const LinearGradient(
    colors: const [lightGradientStart, lightGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  ///theme 3
  static const Color darkGradientStart = const Color(0xFF434343);
  static const Color darkGradientEnd = const Color(0xFF868f96);

  static const darkGradient = const LinearGradient(
    colors: const [darkGradientStart, darkGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static getGradientPrinaryColor(Themes type) {
    switch (type) {
      case Themes.dark:
        return darkGradient;
      case Themes.light:
        return lightGradient;
      case Themes.organizer:
        return orangeGradient;
      default:
        return lightGradient;
    }
  }

  static getLinearGradientColor(Color startColor, Color endColor) =>
      LinearGradient(
          colors: [startColor, endColor],
          stops: const [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
}
