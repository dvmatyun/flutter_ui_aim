import 'package:custom_ui/features/custom_localization/custom_localization_scope.dart';
import 'package:flutter/material.dart';
import 'package:custom_ui/features/core/presentation/modals/alert_dialog_aim.dart';

import 'error_modal.dart';

/// {@template remove_booking_modal}
/// MessageModal widget #modal
/// {@endtemplate}
class MessageModal extends StatefulWidget {
  /// {@macro remove_booking_modal}
  const MessageModal({required this.message, super.key});

  final String message;

  static Future<bool> onShowModal(BuildContext context, {required String title, required String message}) async {
    //final localization = Localization.of(context);
    //localization.
    ErrorModal.onModalShown?.call();
    final result = await BottomSheetAim.flexible(
      body: MessageModal(message: message),
      title: Text(title),
    ).show(context);
    if (result is bool && result) {
      return true;
    }
    return false;
  }

  @override
  State<MessageModal> createState() => _MessageModalState();
}

/// State for widget MessageModal
class _MessageModalState extends State<MessageModal> {
  @override
  Widget build(BuildContext context) {
    final localization = CustomUiScope.of(context);
    //final textTheme = QyreTheme.of(context).textTheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            widget.message,
            //style: textTheme.regular15.copyWith(
            //  color: QyreColors.black100,
            //),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                localization.yes,
                style: textTheme.bodyMedium ?? const TextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
