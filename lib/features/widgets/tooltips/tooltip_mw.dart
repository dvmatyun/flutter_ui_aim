import 'package:custom_ui/features/widgets/buttons/thin_tappable_button.dart';
import 'package:flutter/material.dart';
// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_ui/custom_ui.dart';

/// A material design tooltip.
///
/// Tooltips provide text labels which help explain the function of a button or
/// other user interface action. Wrap the button in a [Tooltip] widget and provide
/// a message which will be shown when the widget is long pressed.
///
/// Many widgets, such as [IconButton], [FloatingActionButton], and
/// [PopupMenuButton] have a `tooltip` property that, when non-null, causes the
/// widget to include a [Tooltip] in its build.
///
/// Tooltips improve the accessibility of visual widgets by proving a textual
/// representation of the widget, which, for example, can be vocalized by a
/// screen reader.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=EeEfD5fI-5Q}
///
///
/// See also:
///
///  * <https://material.io/design/components/tooltips.html>
///  * [TooltipTheme] or [ThemeData.tooltipTheme]
class TooltipMw extends StatefulWidget {
  /// Creates a tooltip.
  ///
  /// By default, tooltips should adhere to the
  /// [Material specification](https://material.io/design/components/tooltips.html#spec).
  /// If the optional constructor parameters are not defined, the values
  /// provided by [TooltipTheme.of] will be used if a [TooltipTheme] is present
  /// or specified in [ThemeData].
  ///
  /// All parameters that are defined in the constructor will
  /// override the default values _and_ the values in [TooltipTheme.of].
  const TooltipMw({
    required this.message,
    super.key,
    this.height,
    this.iconHeight = 44,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow,
    this.excludeFromSemantics,
    this.decoration,
    this.textStyle,
    this.waitDuration,
    this.showDuration,
    this.child,
  });

  /// The text to display in the tooltip.
  final Widget message;

  /// The height of the tooltip's [child].
  ///
  /// If the [child] is null, then this is the tooltip's intrinsic height.
  final double? height;

  /// Tappable icon height
  final double iconHeight;

  /// The amount of space by which to inset the tooltip's [child].
  ///
  /// Defaults to 16.0 logical pixels in each direction.
  final EdgeInsetsGeometry? padding;

  /// The empty space that surrounds the tooltip.
  ///
  /// Defines the tooltip's outer [Container.margin]. By default, a
  /// long tooltip will span the width of its window. If long enough,
  /// a tooltip might also span the window's height. This property allows
  /// one to define how much space the tooltip must be inset from the edges
  /// of their display window.
  ///
  /// If this property is null, then [TooltipThemeData.margin] is used.
  /// If [TooltipThemeData.margin] is also null, the default margin is
  /// 0.0 logical pixels on all sides.
  final EdgeInsetsGeometry? margin;

  /// The vertical gap between the widget and the displayed tooltip.
  ///
  /// When [preferBelow] is set to true and tooltips have sufficient space to
  /// display themselves, this property defines how much vertical space
  /// tooltips will position themselves under their corresponding widgets.
  /// Otherwise, tooltips will position themselves above their corresponding
  /// widgets with the given offset.
  final double? verticalOffset;

  /// Whether the tooltip defaults to being displayed below the widget.
  ///
  /// Defaults to true. If there is insufficient space to display the tooltip in
  /// the preferred direction, the tooltip will be displayed in the opposite
  /// direction.
  final bool? preferBelow;

  /// Whether the tooltip's [message] should be excluded from the semantics
  /// tree.
  ///
  /// Defaults to false. A tooltip will add a [Semantics] label that is set to
  /// [Tooltip.message]. Set this property to true if the app is going to
  /// provide its own custom semantics label.
  final bool? excludeFromSemantics;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  /// Specifies the tooltip's shape and background color.
  ///
  /// The tooltip shape defaults to a rounded rectangle with a border radius of
  /// 4.0. Tooltips will also default to an opacity of 90% and with the color
  /// [Colors.grey[700]] if [ThemeData.brightness] is [Brightness.dark], and
  /// [Colors.white] if it is [Brightness.light].
  final Decoration? decoration;

  /// The style to use for the message of the tooltip.
  final TextStyle? textStyle;

  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Once the pointer leaves the widget, the tooltip will immediately
  /// disappear.
  ///
  /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
  final Duration? waitDuration;

  /// The length of time that the tooltip will be shown after a long press
  /// is released.
  ///
  /// Defaults to 1.5 seconds.
  final Duration? showDuration;

  @override
  _TooltipMwState createState() => _TooltipMwState();
}

class _TooltipMwState extends State<TooltipMw> with SingleTickerProviderStateMixin {
  static const double _defaultTooltipHeight = 32;
  static const double _defaultVerticalOffset = 24;
  static const bool _defaultPreferBelow = true;
  static const EdgeInsetsGeometry _defaultPadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsetsGeometry _defaultMargin = EdgeInsets.zero;
  static const Duration _fadeInDuration = Duration(milliseconds: 250);
  static const Duration _fadeOutDuration = Duration(milliseconds: 250);
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultWaitDuration = Duration.zero;
  static const bool _defaultExcludeFromSemantics = false;

  double? height;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  Decoration? decoration;
  TextStyle? textStyle;
  double? verticalOffset;
  bool? preferBelow;
  late bool excludeFromSemantics;
  late AnimationController _controller;
  OverlayEntry? _entry;
  Duration? showDuration;
  late Duration waitDuration;
  bool? _mouseIsConnected;

  bool _isLocked = false;
  Timer? _lockTimer;

  @override
  void initState() {
    super.initState();
    _mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    _controller = AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
    // Listen to see when a mouse is added.
    RendererBinding.instance.mouseTracker.addListener(_handleMouseTrackerChange);
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  // Forces a rebuild if a mouse has been added or removed.
  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }
    final mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _hideTooltip(immediately: true);
    }
  }

  void _hideTooltip({bool immediately = false}) {
    if (immediately) {
      _removeEntry();
      return;
    }

    // Tool tips activated by hover should disappear as soon as the mouse
    // leaves the control.
    _controller.reverse();
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip was already visible or if the context has
  /// become null.
  bool ensureTooltipVisible() {
    _doLock();
    if (_entry != null) {
      _controller.forward();
      return false; // Already visible.
    }
    _createNewEntry();
    _controller.forward();
    return true;
  }

  void _createNewEntry() {
    final overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );

    final box = context.findRenderObject() as RenderBox?;
    final target = box?.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    // We create this widget outside of the overlay entry's builder to prevent
    // updated values from happening to leak into the overlay when the overlay
    // rebuilds.
    final Widget overlay = Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: TooltipForButtonOverlay(
          message: widget.message,
          height: height,
          padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
          margin: margin,
          decoration: decoration,
          textStyle: textStyle,
          animation: CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
          ),
          target: target ?? const Offset(0, 0),
          verticalOffset: verticalOffset,
          preferBelow: preferBelow,
          onPressed: _hideTooltip,
          positionParams: OverlayPositionParams(
            verticalOffset: verticalOffset ?? 32,
            triangleSide: null,
          ),
        ),
      ),
    );
    _entry = OverlayEntry(builder: (context) => overlay);
    overlayState.insert(_entry!);
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  void _handlePointerEvent(PointerEvent event) {
    if (_entry == null) {
      return;
    }
    if (_isLocked) {
      return;
    }
    _hideTooltip();
  }

  @override
  void deactivate() {
    if (_entry != null) {
      _hideTooltip(immediately: true);
    }
    super.deactivate();
  }

  void _doLock() {
    _isLocked = true;
    _lockTimer?.cancel();
    _lockTimer = Timer(_defaultShowDuration, _cancelLock);
  }

  void _cancelLock() {
    _isLocked = false;
    _lockTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelLock();
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
    RendererBinding.instance.mouseTracker.removeListener(_handleMouseTrackerChange);
    if (_entry != null) {
      _removeEntry();
    }
    _controller.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    if (_entry != null) {
      _hideTooltip();
      return;
    }
    final tooltipCreated = ensureTooltipVisible();
    if (tooltipCreated) {
      Feedback.forLongPress(context);
    }
  }

  void _handleTap() {
    if (_entry != null) {
      _hideTooltip();
      return;
    }
    final tooltipCreated = ensureTooltipVisible();
    if (tooltipCreated) {
      Feedback.forLongPress(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tooltipTheme = TooltipTheme.of(context);

    height = widget.height ?? tooltipTheme.height ?? _defaultTooltipHeight;
    padding = widget.padding ?? tooltipTheme.padding ?? _defaultPadding;
    margin = widget.margin ?? tooltipTheme.margin ?? _defaultMargin;
    verticalOffset = widget.verticalOffset ?? tooltipTheme.verticalOffset ?? _defaultVerticalOffset;
    preferBelow = widget.preferBelow ?? tooltipTheme.preferBelow ?? _defaultPreferBelow;
    excludeFromSemantics =
        widget.excludeFromSemantics ?? tooltipTheme.excludeFromSemantics ?? _defaultExcludeFromSemantics;
    decoration = widget.decoration ?? tooltipTheme.decoration;
    textStyle = widget.textStyle ?? tooltipTheme.textStyle;
    waitDuration = widget.waitDuration ?? tooltipTheme.waitDuration ?? _defaultWaitDuration;
    showDuration = widget.showDuration ?? tooltipTheme.showDuration ?? _defaultShowDuration;

    return ThinTappableButton(
      onLongPress: _handleLongPress,
      onTap: _handleTap,
      //!!!onSecondaryTapCancel: _handleTap,
      child: SizedBox.square(
        dimension: widget.iconHeight,
        child: Semantics(
          child: widget.child,
        ),
      ),
    );
  }
}

class AnimatedOpacityWrapper extends StatefulWidget {
  /// {@macro tooltip_mw}
  const AnimatedOpacityWrapper({required this.child, this.msDuration = 200, super.key});

  final Widget child;
  final int msDuration;

  @override
  State<AnimatedOpacityWrapper> createState() => _AnimatedOpacityWrapperState();
}

/// State for widget AnimatedOpacityWrapper
class _AnimatedOpacityWrapperState extends State<AnimatedOpacityWrapper> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 50)).then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        visible = true;
      });
    });
  }

  late final opacityDuration = Duration(milliseconds: widget.msDuration);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: opacityDuration,
      opacity: visible ? 1 : 0,
      child: widget.child,
    );
  }
}

class TooltipForButtonOverlay extends StatelessWidget {
  const TooltipForButtonOverlay({
    required this.message,
    this.target = Offset.zero,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.textStyle,
    this.animation,
    this.verticalOffset,
    this.preferBelow,
    this.onPressed,
    this.positionParams,
    this.layerLink,
    this.triangleHorizontalOffset,
    this.compositeOffset = Offset.zero,
  });

  final Widget message;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Animation<double>? animation;
  final Offset target;
  final Offset compositeOffset;
  final double? verticalOffset;
  final bool? preferBelow;
  final VoidCallback? onPressed;
  final OverlayPositionParams? positionParams;
  final LayerLink? layerLink;
  final double? triangleHorizontalOffset;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CompositedTransformFollower(
        link: layerLink ?? LayerLink(),
        targetAnchor: Alignment.topLeft,
        followerAnchor: Alignment.topLeft,
        showWhenUnlinked: true,
        offset: compositeOffset,
        child: CustomSingleChildLayout(
          delegate: _TooltipPositionDelegate(
            target: target,
            verticalOffset: positionParams?.verticalOffset ?? verticalOffset ?? 24,
            preferBelow: preferBelow ?? true,
          ),
          child: animation != null
              ? FadeTransition(
                  opacity: animation!,
                  child: buildChild(context),
                )
              : AnimatedOpacityWrapper(child: buildChild(context)),
        ),
      ),
    );
  }

  // ignore: prefer_expression_function_bodies
  Widget buildChild(BuildContext context) {
    final tooltipTheme = TooltipTheme.of(context);
    final boxDecor = decoration ?? tooltipTheme.decoration;
    // ignore: omit_local_variable_types
    const double minWidth = 200;

    return Stack(
      children: [
        Positioned(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height ?? tooltipTheme.height ?? 32),
              child: DefaultTextStyle(
                style: tooltipTheme.textStyle ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
                child: Container(
                  decoration: boxDecor,
                  padding:
                      padding ?? tooltipTheme.padding ?? const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
                  margin: margin ?? tooltipTheme.margin,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: minWidth, maxWidth: 400),
                          child: message,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4, left: 0),
                        child: ThinTappableButton(
                          onTap: () {
                            if (onPressed == null) {
                              return;
                            }
                            onPressed!();
                          },
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: (layerLink?.leaderSize?.width ?? minWidth) / 2,
          child: CustomPaint(
            size: const Size(24, 16),
            painter: TrianglePainter(
              color: MasterColors.tooltipBackground,
              isTop: positionParams?.triangleSide == TriangleSide.top,
            ),
          ),
        ),
      ],
    );
  }
}

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  _TooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.loosen();

  @override
  // ignore: prefer_expression_function_bodies
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  // ignore: prefer_expression_function_bodies
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    required this.color,
    required this.isTop,
    this.addPadding = 0,
  });

  final Color color;
  final bool isTop;
  final double addPadding;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);
    if (isTop) {
      path
        ..lineTo(size.width / 2, -size.height)
        ..lineTo(0, 0);
    } else {
      path
        ..lineTo(size.width / 2, size.height)
        ..lineTo(0, 0);
    }

    return canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}

/// {@template tooltip_mw_common}
/// TooltipMwCommon widget
/// {@endtemplate}
class TooltipMwCommon extends StatelessWidget {
  /// {@macro tooltip_mw_common}
  const TooltipMwCommon({required this.child, super.key});

  final Widget child;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 44,
      child: DefaultTextStyle(
        style: textTheme.labelMedium ?? const TextStyle(),
        child: TooltipMw(
          message: child,
          child: const Icon(
            Icons.info_outline_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// {@template menu_settings_screen}
/// RowWithTooltip widget
/// {@endtemplate}
class RowWithTooltip extends StatelessWidget {
  /// {@macro menu_settings_screen}
  const RowWithTooltip({required this.tooltipText, required this.child, super.key});

  final Widget child;
  final Widget tooltipText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Flexible(child: child),
        TooltipMwCommon(child: tooltipText),
      ],
    );
  }
}
