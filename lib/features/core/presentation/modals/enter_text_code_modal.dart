import 'package:custom_ui/features/custom_localization/custom_localization_scope.dart';
import 'package:flutter/material.dart';
import 'package:custom_ui/features/core/presentation/modals/alert_dialog_aim.dart';

import 'error_modal.dart';

/// {@template remove_booking_modal}
/// EnterTextCodeModal widget #areyousure
/// {@endtemplate}
class EnterTextCodeModal extends StatefulWidget {
  /// {@macro remove_booking_modal}
  const EnterTextCodeModal({required this.question, super.key});

  final String question;

  static Future<String> onShowModal(BuildContext context, String question) async {
    final localization = CustomUiScope.of(context);
    ErrorModal.onModalShown?.call();

    final result = await BottomSheetAim.flexible(
      body: EnterTextCodeModal(question: question),
      title: Text(localization.enter_code_generic),
    ).show(context);
    if (result is String) {
      return result;
    }
    return '';
  }

  @override
  State<EnterTextCodeModal> createState() => _EnterTextCodeModalState();
}

/// State for widget EnterTextCodeModal
class _EnterTextCodeModalState extends State<EnterTextCodeModal> {
  final teController = TextEditingController();

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
            widget.question,
            //style: textTheme.regular15.copyWith(
            //  color: QyreColors.black100,
            //),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: teController,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop('');
                },
                child: Text(
                  localization.cancel_generic,
                  style: textTheme.bodyMedium ?? const TextStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(teController.text);
                },
                child: Text(
                  localization.submit_generic,
                  style: textTheme.bodyMedium ?? const TextStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
