import 'package:custom_ui/custom_ui.dart';
import 'package:custom_ui/features/theme/domain/entities/color_theme_entity.dart';
import 'package:custom_ui/features/theme/domain/entities/custom_ui_settings.dart';

import '../data/color_themes.dart';

enum CustomThemeType {
  darkBlue;

  ICustomThemeColors get colorTheme {
    return const DarkBlueColorTheme();
  }
}

abstract class ICustomThemeService {
  CustomUiSettings get settings;
  Stream<CustomUiSettings> get settingsStream;

  void setThemeData(CustomThemeType type);
  void setScreenSize(ScreenSizeType type);

  void close();
}
