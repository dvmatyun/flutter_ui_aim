import 'dart:async';

import 'package:custom_ui/features/custom_localization/custom_localization_scope.dart';
import 'package:flutter/material.dart';
import 'package:custom_ui/features/core/presentation/modals/alert_dialog_aim.dart';

/// {@template remove_booking_modal}
/// ErrorModal widget #areyousure
/// {@endtemplate}
class ErrorModal extends StatefulWidget {
  /// {@macro remove_booking_modal}
  const ErrorModal({required this.message, super.key});

  final String message;

  static VoidCallback? onModalShown;

  static Future<void> onShowModal(BuildContext context, String message, {String? title}) async {
    final localization = CustomUiScope.of(context);
    onModalShown?.call();
    //localization.
    await BottomSheetAim.flexible(
      body: ErrorModal(message: message),
      title: Text(title ?? localization.attention),
    ).show(context);
  }

  @override
  State<ErrorModal> createState() => _ErrorModalState();
}

/// State for widget ErrorModal
class _ErrorModalState extends State<ErrorModal> {
  @override
  Widget build(BuildContext context) {
    final localization = CustomUiScope.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.message,
            //style: textTheme.regular15.copyWith(
            //  color: QyreColors.black100,
            //),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                localization.ok,
                style: textTheme.bodyMedium ?? const TextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
