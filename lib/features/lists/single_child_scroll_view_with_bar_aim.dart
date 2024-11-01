import 'package:flutter/material.dart';

/// {@template single_child_scroll_view_with_bar_aim}
/// SingleChildScrollViewWithBarAim widget.
/// {@endtemplate}
class SingleChildScrollViewWithBarAim extends StatelessWidget {
  /// {@macro single_child_scroll_view_with_bar_aim}
  const SingleChildScrollViewWithBarAim({
    required this.controller,
    required this.child,
    this.padding,
    super.key, // ignore: unused_element
  });

  final EdgeInsets? padding;
  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      padding: padding,
      interactive: true,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: controller,
        padding: padding,
        child: child,
      ),
    );
  }
}
