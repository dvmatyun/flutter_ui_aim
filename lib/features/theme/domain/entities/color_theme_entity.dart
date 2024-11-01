import 'dart:ui';

abstract class ICustomThemeColors {
  ColorPair get primary;
  ColorPair get primaryOpacity; // 255 - no opacity

  ColorPair get primaryStrong;

  ColorPair get primaryText;
  ColorPair get secondaryText;
}

class ColorPair {
  final Color dark;
  final Color light;

  const ColorPair(this.dark, this.light);
}
