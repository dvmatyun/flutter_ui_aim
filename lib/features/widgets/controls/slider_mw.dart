import 'package:custom_data/custom_data.dart';
import 'package:flutter/material.dart';

/// {@template slider_mw}
/// SliderMw widget
/// {@endtemplate}
class SliderMw extends StatefulWidget {
  /// {@macro slider_mw}
  const SliderMw({
    required this.initialValue,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 100,
    this.divisions = 5,
    super.key,
  });

  final double initialValue;
  final ValueChanged<double>? onChanged;
  final double minValue;
  final double maxValue;
  final int divisions;

  @override
  State<SliderMw> createState() => _SliderMwState();
}

/// State for widget SliderMw
class _SliderMwState extends State<SliderMw> {
  late double _value = widget.initialValue;
  final debouncer = DebouncerAim(timeout: const Duration(milliseconds: 500));

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  /*
  @override
  void didUpdateWidget(SliderMw oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && _value != widget.initialValue) {
      _value = widget.initialValue;
      if (mounted) {
        setState(() {});
      }
    }
  }
  */

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.minValue,
      max: widget.maxValue,
      divisions: widget.divisions,
      label: _value.toStringAsFixed(1),
      onChanged: (double value) {
        setState(() {
          _value = value;
        });
        debouncer.valueChanged(() {
          widget.onChanged?.call(_value);
        });
      },
    );
  }
}
