import 'package:custom_ui/features/custom_localization/custom_localization_scope.dart';
import 'package:flutter/material.dart';
import 'package:custom_ui/features/core/presentation/modals/alert_dialog_aim.dart';

import 'error_modal.dart';

/// {@template remove_booking_modal}
/// AreYouSureModal widget #areyousure #modal
/// {@endtemplate}
class AreYouSureModal extends StatefulWidget {
  /// {@macro remove_booking_modal}
  const AreYouSureModal({required this.question, this.topper, this.buttonsBottom, super.key});

  final Widget? topper;
  final Widget? buttonsBottom;
  final String question;

  static Future<bool> onShowModal(
    BuildContext context,
    String question,
    Widget? topper,
    Widget? buttonsBottom,
  ) async {
    final localization = CustomUiScope.of(context);
    ErrorModal.onModalShown?.call();
    //localization.
    final result = await BottomSheetAim.flexible(
      body: AreYouSureModal(
        question: question,
        topper: topper,
        buttonsBottom: buttonsBottom,
      ),
      title: Text(localization.attention),
    ).show(context);
    if (result is bool && result) {
      return true;
    }
    return false;
  }

  @override
  State<AreYouSureModal> createState() => _AreYouSureModalState();
}

/// State for widget AreYouSureModal
class _AreYouSureModalState extends State<AreYouSureModal> {
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
          widget.topper ?? const SizedBox(),
          Text(
            widget.question,
            //style: textTheme.regular15.copyWith(
            //  color: QyreColors.black100,
            //),
          ),
          const SizedBox(height: 16),
          widget.buttonsBottom ??Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  localization.no,
                  style: textTheme.bodyMedium ?? const TextStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  localization.yes,
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
