import 'dart:async';

import 'package:custom_ui/custom_ui.dart';
import 'package:custom_ui/features/theme/domain/entities/custom_ui_settings.dart';
import 'package:flutter/material.dart';

import 'text_styles.dart';

// #Theme #theme
class CustomThemeService implements ICustomThemeService {
  final _themeDataController = StreamController<CustomUiSettings>.broadcast();

  CustomThemeType _themeType = CustomThemeType.darkBlue;
  ScreenSizeType _sizeType = ScreenSizeType.verySmall;

  @override
  void setThemeData(CustomThemeType type) {
    if (type == _themeType) {
      return;
    }
    _themeType = type;
    settings = _constructCurrentThemeData(_sizeType);
    _themeDataController.add(settings);
  }

  @override
  void setScreenSize(ScreenSizeType type) {
    if (type == _sizeType) {
      return;
    }
    _sizeType = type;
    settings = _constructCurrentThemeData(type);
    _themeDataController.add(settings);
  }

  @override
  Stream<CustomUiSettings> get settingsStream => _themeDataController.stream;

  @override
  void close() {
    _themeDataController.close();
  }

  CustomUiSettings _constructCurrentThemeData(ScreenSizeType type) {
    final colors = _themeType.colorTheme;
    final textStyles = TextStylesCustom(_sizeType, colors);

    final defaultButtonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      backgroundColor: WidgetStateProperty.all(colors.primary.light),
      foregroundColor: WidgetStateProperty.all(colors.primaryText.light), // This is applied even for TextStyle
      shadowColor: WidgetStateProperty.all(colors.primaryStrong.light),
      overlayColor: WidgetStateProperty.all(colors.primaryOpacity.dark),
      elevation: WidgetStateProperty.all(2),
      textStyle: WidgetStateProperty.all(
        textStyles.textStyle.copyWith(
          fontSize: textStyles.mediumFontSize2,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      unselectedWidgetColor: colors.primaryStrong.light,
      primaryColorLight: colors.primary.light,
      primaryColorDark: colors.primaryStrong.dark,
      primaryColor: colors.primary.dark,
      hintColor: colors.primary.dark,
      shadowColor: colors.primaryOpacity.dark,

      iconButtonTheme: IconButtonThemeData(style: defaultButtonStyle),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        padding: EdgeInsets.zero,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 14, color: MasterColors.white20)),
          foregroundColor: WidgetStateProperty.all(MasterColors.white20),
          shape: WidgetStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        ),
      ),
      //primarySwatch: Colors.white,
      primaryTextTheme: textStyles.theme,
      scaffoldBackgroundColor: MasterColors.blue90,
      appBarTheme: const AppBarTheme(backgroundColor: MasterColors.blue79),
      textTheme: textStyles.theme,

      colorScheme: ColorScheme(
        primary: colors.primary.dark,
        onPrimary: colors.primaryText.dark,
        secondary: colors.primaryStrong.dark,
        onSecondary: colors.primaryText.dark,
        error: MasterColors.redBright,
        onError: colors.primaryText.dark,
        surface: MasterColors.primaryLight,
        onSurface: colors.primaryText.light,
        brightness: Brightness.dark,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MasterColors.primaryLight,
        selectionColor: MasterColors.primaryLight.withAlpha(60),
        selectionHandleColor: MasterColors.primaryLight.withAlpha(200),
      ),

      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        hoverColor: MasterColors.primaryLight,
        errorStyle: const TextStyle(color: MasterColors.redBright),
        labelStyle: textStyles.textStyle.copyWith(color: colors.primary.light),
        counterStyle: textStyles.textStyle.copyWith(color: colors.primary.light),
        focusColor: MasterColors.primaryLight,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: MasterColors.primaryLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: MasterColors.primaryLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: MasterColors.redBright,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: MasterColors.redBright,
            width: 1,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      tooltipTheme: $tooltipTheme,
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(MasterColors.primaryLight),
        trackColor: WidgetStateProperty.all(MasterColors.primaryLight),
        trackBorderColor: WidgetStateProperty.all(MasterColors.primaryLight),
        thumbVisibility: WidgetStateProperty.all(true),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: defaultButtonStyle,
      ),
    );
    return CustomUiSettings(theme);
  }

  @override
  late CustomUiSettings settings = _constructCurrentThemeData(_sizeType);

  final TooltipThemeData $tooltipTheme = TooltipThemeData(
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: MasterColors.tooltipBackground,
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

mixin MasterColors {
  //Color(0xFF111111)
  static const Color primaryDark = Color.fromARGB(255, 10, 18, 66);
  static const Color primaryDarkOpacity80 = Color.fromARGB(40, 10, 18, 66);

  static const Color primary = Color.fromARGB(255, 38, 47, 109);
  static const Color primaryLight = Color.fromARGB(255, 215, 219, 250);

  //C5CAE9
  //303F9F

  //3F51B5

  ///
  static const Color blue90 = Color.fromRGBO(22, 35, 52, 1);
  static const Color blue90opacity80 = Color.fromRGBO(22, 35, 52, 0.2);
  static const Color blue80 = Color.fromRGBO(29, 47, 71, 1);

  static const Color blue79 = Color.fromRGBO(24, 66, 123, 1);
  static const Color blue70 = Color.fromRGBO(21, 86, 108, 1);
  static const Color blue60 = Color.fromRGBO(30, 100, 140, 1);

  static const Color blue30 = Color.fromRGBO(126, 184, 204, 1);
  static const Color blue10 = Color.fromRGBO(223, 254, 249, 1);

  static const Color teal15 = Color.fromARGB(255, 145, 255, 237);

  static const Color white10 = Color.fromRGBO(219, 220, 225, 1);
  static const Color white20 = Color.fromRGBO(203, 203, 253, 1);

  static const Color greyBlue10 = Color.fromRGBO(108, 124, 191, 1);
  static const Color greyBlue30 = Color.fromRGBO(143, 155, 195, 1);
  static const Color greyBlue60 = Color.fromRGBO(55, 62, 140, 1);
  static const Color grey30 = Color.fromRGBO(74, 82, 101, 1);

  static const Color starColor = Colors.deepOrange;

  static const Color redLight = Color.fromARGB(255, 253, 100, 89);

  /// Tooltips:
  static Color tooltipBackground = Colors.black.withOpacity(0.9);

  /// UI elements:
  static const Color dropDownListColor = Color.fromRGBO(24, 66, 123, 0.92);

  ///Culture:
  static const Color cultureMainColor = Color.fromARGB(255, 168, 77, 184);

  ///Science:
  static const Color scienceMainColor = Colors.lightBlue;

  static const Color benefitColor = Colors.lightGreen;
  static const Color govenmentColor = Colors.orange;
  static const Color unitMainColor = Colors.purple;

  static Color get backgroundChevron => Colors.purple[700]!.withOpacity(0.5);
  static const Color buildingTypeColor = teal15;

  static const Color failColor = Color.fromARGB(255, 255, 17, 0);
  static const Color successColor = Color.fromARGB(255, 0, 255, 8);

  static const List<Color> gradientDarkColors = [
    Color.fromRGBO(9, 18, 33, 1),
    Color.fromRGBO(15, 46, 75, 1),
    Color.fromRGBO(15, 46, 75, 1),
    Color.fromRGBO(9, 18, 33, 1),
  ];
  static Gradient gradientDark() => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientDarkColors,
      );

  //
  static const black100 = Color(0xFF111111);
  static const black95 = Color(0xFF1C1C1C);
  static const black100Alpha80 = Color(0xCC111111);
  static const black50 = Color(0xFF444444);
  static const black50Alpha20 = Color(0x33444444);
  static const black10 = Color(0xFF656565);
  static const gray100 = Color(0xFF9C9C9C);
  static const gray80 = Color(0xFFCDCECE);
  static const gray50 = Color(0xFFE7EAEA);
  static const gray25 = Color(0xFFF0F2F5);
  static const white100 = Color(0xFFFFFFFF);
  static const white100Alpha80 = Color(0xCCFFFFFF);

  static const standardGrey = Color(0xFF444444);

  static const purpleFaded = Color(0xFF99B4DD);
  static const blueFaded = Color(0xFF87C6F5);
  static const blueBright = Color(0xFF4198FF);
  static const popBlue = Color(0xFF2272F8);
  static const shadeBlue = Color(0xFF0544AD);
  static const greenFaded = Color(0xFF87B7B4);
  static const greenBright = Color(0xFF5EB5A5);
  static const popGreen = Color(0xFF5ED8AF);
  static const shadeGreen = Color(0xFF23906B);
  static const redFaded = Color(0xFFD3918A);
  static const redDark = Color(0xFFD86357);
  static const redBright = Color(0xFFEC4E27);
  static const popOrange = Color(0xFFFF4C00);
  static const shadeOrange = Color(0xFFB23600);
  static const yellowFaded = Color(0xFFE0C584);
  static const yellowBright = Color(0xFFFFB400);
  static const popYellow = Color(0xFFF4B73F);
  static const shadeYellow = Color(0xFFA9730A);
  static const popPurple = Color(0xFF8E5EDB);
  static const shadePurple = Color(0xFF4C2192);
}
