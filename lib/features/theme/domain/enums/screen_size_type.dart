import 'package:flutter/material.dart';

extension BuildContextSizeExt on BuildContext {
  T size<T>({
    required T Function() verySmall,
    required T Function() small,
    required T Function() normal,
    required T Function() big,
    required T Function() veryBig,
  }) =>
      switch (MediaQuery.of(this).size.width) {
        > _veryBig => veryBig(),
        > _big => big(),
        > _normal => normal(),
        > _small => small(),
        _ => verySmall(),
      };

  T maybeSize<T>({
    required T Function() orElse,
    T Function()? verySmall,
    T Function()? small,
    T Function()? normal,
    T Function()? big,
    T Function()? veryBig,
  }) =>
      switch (MediaQuery.of(this).size.width) {
        > _veryBig => veryBig?.call() ?? orElse(),
        > _big => big?.call() ?? orElse(),
        > _normal => normal?.call() ?? orElse(),
        > _small => small?.call() ?? orElse(),
        _ => verySmall?.call() ?? orElse(),
      };
}

const double _tiny = 300;
const double _verySmall = 350;
const double _small = 400;
const double _normal = 650;
const double _big = 1000;
const double _veryBig = 1500;
const double _huge = 2000;

enum ScreenSizeType {
  tiny(0, _tiny),
  verySmall(1, _verySmall), // less then _small
  small(2, _small), // less then _normal
  normal(3, _normal), // less then _big
  big(4, _big), // less then _veryBig
  veryBig(5, _veryBig), // more then 1900
  huge(6, _huge);

  final int value;
  final double size;
  const ScreenSizeType(this.value, this.size);

  bool get isBig => value >= 4;
  bool get isNormal => value >= 3;

  factory ScreenSizeType.of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return switch (width) {
      > _huge => ScreenSizeType.huge,
      > _veryBig => ScreenSizeType.veryBig,
      > _big => ScreenSizeType.big,
      > _normal => ScreenSizeType.normal,
      > _small => ScreenSizeType.small,
      > _verySmall => ScreenSizeType.verySmall,
      _ => ScreenSizeType.tiny,
    };
  }

  factory ScreenSizeType.ofHeight(BuildContext context) {
    return switch (MediaQuery.sizeOf(context).height) {
      > _huge => ScreenSizeType.huge,
      > _veryBig => ScreenSizeType.veryBig,
      > _big => ScreenSizeType.big,
      > _normal => ScreenSizeType.normal,
      > _small => ScreenSizeType.small,
      > _verySmall => ScreenSizeType.verySmall,
      _ => ScreenSizeType.tiny,
    };
  }

  factory ScreenSizeType.size(double size) {
    return switch (size) {
      > _huge => ScreenSizeType.huge,
      > _veryBig => ScreenSizeType.veryBig,
      > _big => ScreenSizeType.big,
      > _normal => ScreenSizeType.normal,
      > _small => ScreenSizeType.small,
      > _verySmall => ScreenSizeType.verySmall,
      _ => ScreenSizeType.tiny,
    };
  }

  double? get expectedScreenWidth {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
      case ScreenSizeType.small:
        return null;
      default:
        return size - 32;
    }
  }

  double getBaseDimension() {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 2;
      case ScreenSizeType.small:
        return 3;
      case ScreenSizeType.normal:
        return 8;
      case ScreenSizeType.big:
        return 16;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 64;
    }
  }

  double get tinyPadding {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 2;
      case ScreenSizeType.small:
        return 3;
      case ScreenSizeType.normal:
        return 4;
      case ScreenSizeType.big:
        return 5;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 6;
    }
  }

  double get borderWidth {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 1;
      case ScreenSizeType.small:
        return 2;
      case ScreenSizeType.normal:
        return 3;
      case ScreenSizeType.big:
        return 4;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 5;
    }
  }

  double get smallPadding {
    return tinyPadding * 2;
  }

  double get tooltipSymmetricPadding {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 0;
      case ScreenSizeType.small:
        return 44;
      case ScreenSizeType.normal:
        return 44;
      case ScreenSizeType.big:
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 44;
    }
  }

  double? get buttonWidthWithTooltip {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return null;
      default:
        return (buttonWidth ?? 300) + tooltipSymmetricPadding * 2;
    }
  }

  double get padding {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 6;
      case ScreenSizeType.small:
        return 8;
      case ScreenSizeType.normal:
        return 12;
      case ScreenSizeType.big:
        return 16;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 20;
    }
  }

  double get paddingOptional {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 1;
      case ScreenSizeType.small:
        return 2;
      case ScreenSizeType.normal:
        return 8;
      case ScreenSizeType.big:
        return 16;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 32;
    }
  }

  double get screenWidthPadding {
    switch (this) {
      case ScreenSizeType.tiny:
        return 2;
      case ScreenSizeType.verySmall:
        return 8;
      case ScreenSizeType.small:
        return 8;
      case ScreenSizeType.normal:
        return 16;
      case ScreenSizeType.big:
        return 32;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 32;
    }
  }

  double get screenHeightPadding {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 16;
      case ScreenSizeType.small:
        return 16;
      case ScreenSizeType.normal:
        return 32;
      case ScreenSizeType.big:
        return 64;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 32;
    }
  }

  double getSmallestIconSize() {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 20;
      case ScreenSizeType.small:
        return 26;
      case ScreenSizeType.normal:
        return 32;
      case ScreenSizeType.big:
        return 40;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 64;
    }
  }

  double get iconSizeBig {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 40;
      case ScreenSizeType.small:
        return 60;
      case ScreenSizeType.normal:
        return 80;
      case ScreenSizeType.big:
        return 100;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 128;
      default:
        return 60;
    }
  }

  double get iconSizeMedium {
    //static const double boxSize = 20;
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 20;
      case ScreenSizeType.small:
        return 25;
      case ScreenSizeType.normal:
        return 30;
      case ScreenSizeType.big:
        return 35;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 45;
      default:
        return 20;
    }
  }

  double get iconSizeSmall {
    //static const double boxSize = 20;
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 15;
      case ScreenSizeType.small:
        return 20;
      case ScreenSizeType.normal:
        return 25;
      case ScreenSizeType.big:
        return 30;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 40;
      default:
        return 20;
    }
  }

  double get iconSizeTiny {
    //static const double boxSize = 20;
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 10;
      case ScreenSizeType.small:
        return 12;
      case ScreenSizeType.normal:
        return 14;
      case ScreenSizeType.big:
        return 18;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 22;
      default:
        return 20;
    }
  }

  double get iconSizeInText {
    //static const double boxSize = 20;
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 20;
      case ScreenSizeType.small:
        return 28;
      case ScreenSizeType.normal:
        return 30;
      case ScreenSizeType.big:
        return 34;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 42;
      default:
        return 24;
    }
  }

  double get buttonSizeSquare {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 40;
      case ScreenSizeType.small:
        return 60;
      case ScreenSizeType.normal:
        return 70;
      case ScreenSizeType.big:
        return 100;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 128;
      default:
        return 60;
    }
  }

  double get modalScreenWidthNormalMax {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
      case ScreenSizeType.small:
        return 400;
      case ScreenSizeType.normal:
        return 500;
      case ScreenSizeType.big:
        return 600;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return _big;
      default:
        return 400;
    }
  }

  double get listViewHeight {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
      case ScreenSizeType.small:
        return 200;
      case ScreenSizeType.normal:
        return 400;
      case ScreenSizeType.big:
        return 600;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 800;
      default:
        return 400;
    }
  }

  double get listViewHeightSmall {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
      case ScreenSizeType.small:
        return 200;
      case ScreenSizeType.normal:
        return 300;
      case ScreenSizeType.big:
        return 400;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 500;
      default:
        return 400;
    }
  }

  double get smallPhraseWidth {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 100;
      case ScreenSizeType.small:
        return 100;
      case ScreenSizeType.normal:
        return 140;
      case ScreenSizeType.big:
        return 140;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 150;
      default:
        return 80;
    }
  }

  double get buttonSizeSquareBig {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 70;
      case ScreenSizeType.small:
        return 80;
      case ScreenSizeType.normal:
        return 90;
      case ScreenSizeType.big:
        return 120;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 150;
      default:
        return 80;
    }
  }

  double? get formWidth {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return null;
      case ScreenSizeType.small:
        return null;
      case ScreenSizeType.normal:
        return 340;
      case ScreenSizeType.big:
        return 380;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 420;
      default:
        return 300;
    }
  }

  static const double baseWidth = 220;
  double get formWidthSmall {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return baseWidth - 40;
      case ScreenSizeType.small:
        return baseWidth + 20;
      case ScreenSizeType.normal:
        return baseWidth + 40;
      case ScreenSizeType.big:
        return baseWidth + 60;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return baseWidth + 80;
      default:
        return baseWidth;
    }
  }

  double get formHeightSmall {
    const baseHeight = 32.0;
    const step = 4.0;
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return baseHeight;
      case ScreenSizeType.small:
        return baseHeight + step;
      case ScreenSizeType.normal:
        return baseHeight + 2 * step;
      case ScreenSizeType.big:
        return baseHeight + 3 * step;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return baseHeight + 4 * step;
      default:
        return baseHeight;
    }
  }

  double? get buttonWidth {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return null;
      case ScreenSizeType.small:
        return 320;
      case ScreenSizeType.normal:
        return 340;
      case ScreenSizeType.big:
        return 380;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 420;
      default:
        return 300;
    }
  }

  // 2 in one row with screen padding:
  double get buttonWidthSmall {
    return 110 + widthScalingSmall * 2;
  }

  double get buttonWidthMedium {
    return 130 + widthScalingSmall * 4;
  }

  double get textWrappedWidth {
    switch (this) {
      case ScreenSizeType.tiny:
        return 140;
      case ScreenSizeType.verySmall:
        return 180;
      case ScreenSizeType.small:
        return 200;
      case ScreenSizeType.normal:
        return 220;
      case ScreenSizeType.big:
        return 240;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 300;
      default:
        return 120;
    }
  }

  double get textWrappedWideWidth {
    switch (this) {
      case ScreenSizeType.tiny:
        return 150;
      case ScreenSizeType.verySmall:
        return 180;
      case ScreenSizeType.small:
        return 220;
      case ScreenSizeType.normal:
        return 300;
      case ScreenSizeType.big:
        return 350;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 400;
      default:
        return 120;
    }
  }

  double? get buttonHeight {
    return 40 + heightScaling;
  }

  double? get buttonHeightSmall {
    return 40 + heightScalingSmall;
  }

  double get tabHeight {
    const baseValue = 32.0;
    final heightScaling = this.heightScaling;
    return baseValue + heightScaling;
  }

  double get heightScaling {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 0;
      case ScreenSizeType.small:
        return 4;
      case ScreenSizeType.normal:
        return 8;
      case ScreenSizeType.big:
        return 16;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 32;
    }
  }

  double get widthScalingSmall {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 0;
      case ScreenSizeType.small:
        return 8;
      case ScreenSizeType.normal:
        return 16;
      case ScreenSizeType.big:
        return 32;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 64;
    }
  }

  double get heightScalingSmall {
    switch (this) {
      case ScreenSizeType.tiny:
      case ScreenSizeType.verySmall:
        return 0;
      case ScreenSizeType.small:
        return 2;
      case ScreenSizeType.normal:
        return 4;
      case ScreenSizeType.big:
        return 8;
      case ScreenSizeType.veryBig:
      case ScreenSizeType.huge:
        return 16;
    }
  }

  double getOverlayWithResourcesHeight() => 16 + getSmallestIconSize() * 2;
}
