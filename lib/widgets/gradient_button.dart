import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class GradientButton extends StatelessWidget {
  /// Final label used by the button. Accepts either `text:` or `buttonText:`.
  final String text;

  /// Nullable so callers can pass `null` to disable the button.
  final VoidCallback? onPressed;

  const GradientButton({
    Key? key,
    String? text,
    String? buttonText, // legacy support
    this.onPressed,
  }) : text = text ?? buttonText ?? '',
       assert(
         (text != null && text != '') ||
             (buttonText != null && buttonText != ''),
         'Provide `text:` or `buttonText:` to GradientButton.',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.buttonStart, AppColors.buttonEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
