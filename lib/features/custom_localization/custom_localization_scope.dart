// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';

class CustomUiScope extends InheritedWidget {
  const CustomUiScope({
    required this.dataLocalization,
    required super.child,
    super.key,
  });

  final CustomLocalizationData dataLocalization;

  @override
  bool updateShouldNotify(CustomUiScope oldWidget) {
    return oldWidget.dataLocalization != dataLocalization;
  }

  /// example: final brightness = QyreBrightness.of(context);
  static CustomLocalizationData of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<CustomUiScope>()!;
    return data.dataLocalization;
  }
}

class CustomLocalizationData {
  const CustomLocalizationData({
    required this.back_btn,
    required this.ads_are_not_supported_on_this_platform,
    required this.attention,
    required this.yes,
    required this.no,
    required this.enter_code_generic,
    required this.cancel_generic,
    required this.submit_generic,
    required this.ok,
    required this.attack_missed_short,
    this.otherMap = const <String, String>{},
  });

  final String back_btn;
  final String ads_are_not_supported_on_this_platform;
  final String attention;
  final String yes;
  final String no;
  final String enter_code_generic;
  final String cancel_generic;
  final String submit_generic;
  final String ok;

  // game related:
  final String attack_missed_short;

  final Map<String, String> otherMap;
}
