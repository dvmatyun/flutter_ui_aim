import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget for Thin (scale) animation.
///
/// If [thinned] is `true` then [child]'s scale is sets to [_thinnedScale] else it sets to 1.
class AnimatedThin extends StatefulWidget {
  const AnimatedThin({
    required this.thinned,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 100),
    this.enabled = true,
    this.scale = 0.93,
    super.key,
  });

  final bool thinned;

  final bool enabled;

  final Widget child;

  final Duration animationDuration;

  final double scale;

  @override
  State<AnimatedThin> createState() => _AnimatedThinState();
}

class _AnimatedThinState extends State<AnimatedThin> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedScale(
      curve: Curves.easeOut,
      scale: widget.thinned ? widget.scale : 1,
      duration: widget.animationDuration,
      child: widget.child,
    );
  }
}

/// This widget is used to create button with Thin animation.
///
/// Thin animation means that on tap button's background will be a bit minimized however [child]
/// won't change its size.
///
/// Unlike [QyreThinButtonBase] this widget can be used by the end user to animate some widget.
/// Usually inkwell is used to animate tappable widget however in our design system we use Thin animation instead.
/// Also maybe develop [TappableElementQyre]
class ThinTappableButton extends StatefulWidget {
  const ThinTappableButton({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.initialTapped = false,
    this.decoratedForClick = false,
    this.animatedForExampleClick = false,
    this.scale = 0.93,
    this.skip = false,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Widget which will be animated.
  final Widget child;

  final bool enabled;

  final bool initialTapped;
  final bool decoratedForClick;

  final bool animatedForExampleClick;
  final double scale;
  final bool skip;

  @override
  State<ThinTappableButton> createState() => _QyreThinTappableState();
}

class _QyreThinTappableState extends State<ThinTappableButton> {
  late bool _tapped = widget.initialTapped;

  bool get _isEnabled => widget.decoratedForClick || (widget.enabled && widget.onTap != null);
  Timer? longPressTimer;

  final ValueNotifier<bool> hoveredNotifier = ValueNotifier(false);

  // ignore: use_setters_to_change_properties
  void _onHoverChange(bool isHovered) {
    hoveredNotifier.value = isHovered;
  }

  @override
  void initState() {
    super.initState();
    if (widget.animatedForExampleClick) {
      Timer(const Duration(seconds: 5), () async {
        if (_tapped) {
          return;
        }
        if (!mounted) {
          return;
        }
        setState(() => _tapped = true);
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!mounted) {
          return;
        }
        setState(() => _tapped = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skip) {
      return widget.child;
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: CustomPaint(
        foregroundPainter: OutlineFocusButtonPainter(
          showCommands: hoveredNotifier,
          focusedBorderColor: theme.buttonTheme.colorScheme?.primary ?? Colors.white,
          focusedBorderWidth: 2,
        ),
        child: InkWell(
          //behavior: widget.behavior,
          onHover: (value) {
            if (!widget.enabled) {
              if (hoveredNotifier.value) {
                _onHoverChange(false);
              }
              return;
            }
            _onHoverChange(value);
          },
          onTapDown: (_) {
            _setTapped();
          },
          onTapUp: (_) => _onTapUp(),
          onTapCancel: _setUnTapped,
          child: AnimatedThin(
            scale: widget.scale,
            thinned: _tapped,
            enabled: widget.enabled,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _onTapUp() {
    if (_isEnabled) {
      widget.onTap?.call();
    }
    _setUnTapped();
  }

  void _setUnTapped() {
    _onHoverChange(false);
    setState(() => _tapped = false);
    longPressTimer?.cancel();
  }

  void _setTapped() {
    if (_isEnabled) {
      setState(() => _tapped = true);
    }
    if (widget.onLongPress == null) {
      return;
    }
    longPressTimer = Timer(const Duration(milliseconds: 500), () {
      if (_tapped) {
        widget.onLongPress?.call();
      }
    });
  }
}

class OutlineFocusButtonPainter extends CustomPainter {
  OutlineFocusButtonPainter({
    required ValueListenable<bool> showCommands,
    required Color focusedBorderColor,
    required double focusedBorderWidth,
    this.padding = 1,
  })  : _showCommands = showCommands,
        _paint = Paint()
          ..color = focusedBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = focusedBorderWidth,
        super(repaint: showCommands);

  final ValueListenable<bool> _showCommands;
  final Paint _paint;
  final double padding;
  @override
  void paint(Canvas canvas, Size size) {
    if (!_showCommands.value) {
      return;
    }
    canvas.drawRRect(
        RRect.fromLTRBR(
          -padding,
          -padding,
          size.width + padding,
          size.height + padding,
          Radius.zero,
        ),
        _paint);
    //canvas.drawRRect(RRect.fromLTRBR(0, 0, size.width, size.height, Radius.zero), _paint);
  }

  @override
  bool shouldRepaint(OutlineFocusButtonPainter oldDelegate) =>
      !identical(_showCommands, oldDelegate._showCommands) ||
      _paint.color != oldDelegate._paint.color ||
      _paint.strokeWidth != oldDelegate._paint.strokeWidth;

  @override
  bool shouldRebuildSemantics(OutlineFocusButtonPainter oldDelegate) => false;
}
