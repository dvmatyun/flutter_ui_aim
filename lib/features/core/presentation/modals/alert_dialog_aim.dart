// ignore_for_file: unused_element

import 'dart:math';
import 'dart:ui';

import 'package:custom_ui/features/custom_localization/custom_localization_scope.dart';
import 'package:flutter/material.dart';

const kVerySmallHeightFactor = 0.4;
const kSmallHeightFactor = 0.5;
const kMediumHeightFactor = 0.6;
const kBigHeightFactor = 0.93;
const kVeryBigHeightFactor = 0.99;

enum BottomSheetAimSize {
  verySmall(kVerySmallHeightFactor),
  small(kSmallHeightFactor),
  medium(kMediumHeightFactor),
  big(kBigHeightFactor),
  veryBig(kVeryBigHeightFactor);

  const BottomSheetAimSize(this.sizeFactor);

  final double sizeFactor;
}

/// {@template qyre_bottom_sheet_v2}
/// BottomSheetQyre widget. Used just to understand is current screen is bottom sheet
/// {@endtemplate}
class BottomSheetAimWrapped extends StatelessWidget {
  /// {@macro qyre_bottom_sheet_v2}
  const BottomSheetAimWrapped({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// #modal #bottom #window
/// Bottom sheet component which can be with [title], [body], and [action]
/// buttons and different size (small by default)
///
/// Usage example:
/// QyreBottomSheetV2.fixedSize(title: 'title', body: Widget()).show(context);
///
/// You can choose BottomSheet's size by [size] field
/// [BottomSheetAimSize.verySmall] will display BottomSheet at 0.35 of screen height
/// [BottomSheetAimSize.small] will display BottomSheet at 0.5 of screen height
/// [BottomSheetAimSize.big] will display BottomSheet at 0.9 of screen height
///
class BottomSheetAim extends StatelessWidget {
  /// Used for displaying lists.
  /// Need fixed height [BottomSheetAimSize.big] or [BottomSheetAimSize.small],
  const BottomSheetAim.fixedHeight({
    required this.title,
    required this.body,
    this.size = BottomSheetAimSize.small,
    this.headerTrailing,
    this.headerLeading,
    this.useKeyboardPadding = false,
    this.padding = const EdgeInsets.only(bottom: 0),
    this.showDraggableBrick = true,
    super.key,
  });

  /// Used for displaying texts and buttons or other widgets that has fixed size.
  /// [BottomSheetAim] will set his height automatically based on children sizes.
  const BottomSheetAim.flexible({
    required this.title,
    required this.body,
    this.headerTrailing,
    this.headerLeading,
    this.useKeyboardPadding = false,
    this.padding = const EdgeInsets.only(bottom: 0),
    this.showDraggableBrick = true,
    super.key,
  }) : size = null;

  final Widget? title;
  final Widget body;
  final bool useKeyboardPadding;
  final EdgeInsets padding;

  /// {@macro BottomSheetHeaderTrailing}
  final Widget? headerTrailing;
  final Widget? headerLeading;
  final BottomSheetAimSize? size;
  final bool showDraggableBrick;

  /// Shows this dialog on top of all screens.
  Future<T?> show<T>(
    BuildContext context, {
    bool showTitle = true,
    bool isDissmissible = true,
    EdgeInsets? screenPadding,
  }) {
    return showDialog<T?>(
      context: context,
      barrierDismissible: isDissmissible,
      builder: (_) {
        return RepaintBoundary(
          child: AlertDialog(
            insetPadding: screenPadding ??
                (MediaQuery.sizeOf(context).width > 600
                    ? const EdgeInsets.symmetric(horizontal: 32)
                    : const EdgeInsets.symmetric(horizontal: 8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

            shape: const BeveledRectangleBorder(),
            //surfaceTintColor: QyreColors.white100,
            //backgroundColor: QyreColors.white100,
            title: showTitle ? _AlertDialogTitleAim(title: title) : null,
            content: size == null
                ? AlertDialogFlexibleContent(
                    child: body,
                  )
                : AlertDialogSizedContent(
                    sizeFactor: size ?? BottomSheetAimSize.small,
                    child: body,
                  ),
          ),
        );
      },
    );
  }

  static const headerHeight = 53.0;
  static const buttonHeight = 34.0;
  static const headerTotalHeight = headerHeight + buttonHeight;

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Material(
          //color: QyreColors.white100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: useKeyboardPadding ? MediaQuery.of(context).viewInsets.bottom : 0,
            ),
            child: FractionallySizedBox(
              heightFactor: _getHeightFactor(MediaQuery.of(context).size.height),
              child: Stack(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: padding.copyWith(
                        top: padding.top + headerTotalHeight,
                      ),
                      child: body,
                    ),
                  ),
                  if (title != null)
                    BottomSheetHeader(
                      title: title!,
                      trailing: headerTrailing,
                      leading: headerLeading,
                      showDraggableBrick: showDraggableBrick,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        //color: QyreColors.white100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Padding(
          padding: EdgeInsets.only(bottom: useKeyboardPadding ? MediaQuery.of(context).viewInsets.bottom : 0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      BottomSheetHeader(
                        title: title!,
                        trailing: headerTrailing,
                        leading: headerLeading,
                        showDraggableBrick: showDraggableBrick,
                      ),
                    Padding(
                      padding: padding,
                      child: body,
                    ),
                    //const SafeArea(child: SizedBox.shrink()),
                  ],
                ),
              ),
              /*
              if (title != null)
                _BottomSheetHeader(
                  title: title!,
                  trailing: headerTrailing,
                ),
              */
            ],
          ),
        ),
      );
    }
  }

  double heightFactor() {
    switch (size) {
      case BottomSheetAimSize.verySmall:
        return kVerySmallHeightFactor;
      case BottomSheetAimSize.small:
        return kSmallHeightFactor;
      case BottomSheetAimSize.medium:
        return kMediumHeightFactor;
      case BottomSheetAimSize.big:
        return kBigHeightFactor;
      case BottomSheetAimSize.veryBig:
        return kVeryBigHeightFactor;
      default:
        return kSmallHeightFactor;
    }
  }

  double _getHeightFactor(double screenHeight) {
    switch (size) {
      case BottomSheetAimSize.veryBig:
        return kVeryBigHeightFactor;
      case BottomSheetAimSize.big:
        return kBigHeightFactor;
      default:
        final factor = heightFactor();
        final addScreenFactor = (1024 - screenHeight) / 1024;
        final resultFactor = factor + addScreenFactor;
        final result = resultFactor.clamp(kVerySmallHeightFactor, kBigHeightFactor);
        return result;
    }

    /*
    switch (size) {
      case QyreBottomSheetSize.verySmall:
        if (screenHeight < 800) {
          return kSmallHeightFactor;
        }
        return kVerySmallHeightFactor;
      case QyreBottomSheetSize.small:
        return kSmallHeightFactor;
      case QyreBottomSheetSize.medium:
        return kMediumHeightFactor;
      case QyreBottomSheetSize.big:
        return kBigHeightFactor;
      default:
        return kSmallHeightFactor;
    }
    */
  }
}

/// {@template qyre_bottom_sheet_v2}
/// AlertDialogSized widget
/// {@endtemplate}
class AlertDialogSizedContent extends StatelessWidget {
  /// {@macro qyre_bottom_sheet_v2}
  const AlertDialogSizedContent({required this.sizeFactor, required this.child, super.key});

  final BottomSheetAimSize sizeFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double recommendedWidth = max(size.width / 2, 400);
    final double width = min(recommendedWidth, size.width);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width,
        maxWidth: width,
        maxHeight: min(size.height - 64, 256 + size.height * (sizeFactor.sizeFactor * 3 / 4)),
        minHeight: 100,
      ),
      //constraints: BoxConstraints(minWidth: 200, maxWidth: size.width, minHeight: 100, maxHeight: size.height),
      child: child,
    );
  }
}

class AlertDialogFlexibleContent extends StatelessWidget {
  /// {@macro qyre_bottom_sheet_v2}
  const AlertDialogFlexibleContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double maxWidth = max(400, size.width * 3 / 4);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 400,
        maxWidth: maxWidth,
        maxHeight: 600,
        minHeight: 100,
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(size: Size(maxWidth, 600)),
        child: child,
      ),
    );
  }
}

/// {@template qyre_bottom_sheet_v2}
/// _AlertDialogTitleQyre widget
/// {@endtemplate}
class _AlertDialogTitleAim extends StatelessWidget {
  /// {@macro qyre_bottom_sheet_v2}
  const _AlertDialogTitleAim({required this.title});

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: title ?? const SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const SizedBox(
              width: 26,
              height: 26,
              child: Icon(
                Icons.close,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.title,
    this.trailing,
    this.leading,
    this.headerHeight = 53.0,
    this.buttonHeight = 34.0,
    this.showDraggableBrick = true,
    super.key,
  });

  final Widget title;

  final double headerHeight;
  final double buttonHeight;
  final bool showDraggableBrick;

  /// {@template BottomSheetHeaderTrailing}
  /// Displayed on the right side of the header.
  /// AN ideal place for a "Clear" button or something similar.
  /// {@endtemplate}
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final localization = CustomUiScope.of(context);
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: SizedBox(
        height: headerHeight + (showDraggableBrick ? buttonHeight : 0),
        child: QyreBlurredContainer(
          child: Column(
            children: [
              if (showDraggableBrick)
                SizedBox(
                  height: buttonHeight,
                  child: Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        //color: QyreColors.gray80,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: headerHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 50),
                      child: leading ??
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 50),
                                child: Center(
                                  child: Text(
                                    localization.back_btn,
                                    //style: theme.textTheme.medium14.copyWith(
                                    //  color: QyreColors.shadeGreen,
                                    //),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                    DefaultTextStyle(
                      style: theme.textTheme.titleMedium ?? const TextStyle(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textHeightBehavior: const TextHeightBehavior(
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      child: title,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 50),
                      child: trailing ?? const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@template bottom_sheet_header}
/// _AlertDialogHeader widget
/// {@endtemplate}
class _AlertDialogHeader extends StatelessWidget {
  /// {@macro bottom_sheet_header}
  const _AlertDialogHeader({
    required this.title,
    this.trailing,
    this.leading,
    this.headerHeight = 53.0,
    this.buttonHeight = 34.0,
    super.key,
  });

  final Widget title;

  final double headerHeight;
  final double buttonHeight;

  /// {@template BottomSheetHeaderTrailing}
  /// Displayed on the right side of the header.
  /// AN ideal place for a "Clear" button or something similar.
  /// {@endtemplate}
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50),
          child: leading ??
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 50),
                  child: const Center(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
        ),
        Expanded(
          child: DefaultTextStyle(
            style: theme.textTheme.titleMedium ?? const TextStyle(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textHeightBehavior: const TextHeightBehavior(
              leadingDistribution: TextLeadingDistribution.even,
            ),
            child: title,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50),
          child: trailing ?? const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Empty container with blur effect
///
/// Usually used as bottom container for action buttons.
class QyreBlurredContainer extends StatelessWidget {
  const QyreBlurredContainer({
    required this.child,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = backgroundColor ?? theme.cardColor;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
        child: ColoredBox(
          color: color,
          child: child,
        ),
      ),
    );
  }
}
