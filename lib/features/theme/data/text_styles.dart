import 'package:custom_ui/custom_ui.dart';
import 'package:custom_ui/features/theme/domain/entities/color_theme_entity.dart';
import 'package:flutter/material.dart';

class TextStylesCustom {
  static const String defaultFontFamily = 'Montserrat';

  final ScreenSizeType sizeType;
  final ICustomThemeColors themeColors;

  TextStylesCustom(this.sizeType, this.themeColors);

  TextStyle get textStyle => TextStyle(
        fontSize: defaultFontSize,
        fontFamily: defaultFontFamily,
        color: themeColors.primaryText.dark,
      );

  TextTheme get theme => TextTheme(
        labelLarge: TextStyle(
          fontSize: defaultFontSize,
          color: themeColors.primaryText.dark,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: smallFontSize,
          color: themeColors.primaryText.dark,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          fontSize: tinyFontSize,
          color: themeColors.primaryText.dark,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(fontSize: bigFontSize3, color: themeColors.primaryText.dark),
        titleMedium: TextStyle(fontSize: bigFontSize2, color: themeColors.primaryText.dark),
        titleSmall: TextStyle(fontSize: bigFontSize1, color: themeColors.primaryText.dark),
        headlineLarge: TextStyle(fontSize: bigFontSize3, color: themeColors.primaryText.dark),
        headlineMedium: TextStyle(fontSize: defaultFontSize, color: themeColors.primaryText.dark),
        headlineSmall: TextStyle(fontSize: smallFontSize, color: themeColors.primaryText.dark),
        bodyLarge: TextStyle(fontSize: mediumFontSize3, color: themeColors.primaryText.dark),
        bodyMedium: TextStyle(fontSize: mediumFontSize2, color: themeColors.primaryText.dark),
        bodySmall: TextStyle(fontSize: mediumFontSize1, color: themeColors.primaryText.dark),
      );

  double _defaultFontSize(ScreenSizeType size) {
    switch (size) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 14;
      case ScreenSizeType.small:
        return 15;
      case ScreenSizeType.normal:
        return 16;
      case ScreenSizeType.big:
        return 18;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 20;
      default:
        return 14;
    }
  }

  late final defaultFontSize = _defaultFontSize(sizeType);

  static const double fontSizeStep = 2;

  double get tinyFontSize => defaultFontSize - 3 * fontSizeStep;
  double get verySmallFontSize => defaultFontSize - 2 * fontSizeStep;
  double get smallFontSize => defaultFontSize - fontSizeStep;

  double get mediumFontSize1 => defaultFontSize;
  double get mediumFontSize2 => defaultFontSize + fontSizeStep / 2;
  double get mediumFontSize3 => defaultFontSize + fontSizeStep;

  double get bigFontSize1 => defaultFontSize + 1 * fontSizeStep;
  double get bigFontSize2 => defaultFontSize + 2 * fontSizeStep;
  double get bigFontSize3 => defaultFontSize + 4 * fontSizeStep;
}
