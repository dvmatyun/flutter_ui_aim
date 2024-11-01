import 'package:flutter/material.dart';

class OverlayPositionParams {
  const OverlayPositionParams({
    this.verticalOffset = 0,
    this.horizontalOffset = 0,
    this.triangleSide,
    this.showEvenIfPaused = false,
    this.childOffset = Offset.zero,
    this.tryBuildOnScreen, // is not recommended for horizontal scrollable widget
  });

  final double verticalOffset;
  final double horizontalOffset;
  final TriangleSide? triangleSide;
  final bool showEvenIfPaused;
  final Offset childOffset;
  final bool? tryBuildOnScreen;
}

enum TriangleSide {
  top,
  bottom;
}
