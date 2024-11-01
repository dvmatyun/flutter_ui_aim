import 'package:custom_ui/features/theme/domain/entities/color_theme_entity.dart';
import 'package:flutter/material.dart';

class DarkBlueColorTheme implements ICustomThemeColors {
  const DarkBlueColorTheme();

  @override
  ColorPair get primary => const ColorPair(
        Color.fromRGBO(27, 35, 80, 1),
        Color.fromRGBO(197, 202, 233, 1),
      );

  @override
  ColorPair get primaryOpacity => const ColorPair(
        Color.fromRGBO(63, 81, 181, 0.2),
        Color.fromRGBO(215, 219, 250, 0.2),
      );

  @override
  ColorPair get primaryStrong => const ColorPair(
        Colors.black,
        Colors.white,
        //Color.fromRGBO(10, 18, 66, 1),
        //Color.fromRGBO(203, 203, 253, 1),
      );

  @override
  ColorPair get primaryText => const ColorPair(Color(0xFFFFFFFF), Color(0xFF111111));

  @override
  ColorPair get secondaryText => const ColorPair(
        Color.fromRGBO(117, 117, 117, 1),
        Color.fromRGBO(54, 54, 54, 1),
      );
}
