import 'package:flutter/material.dart';
import './/./core/extension/context_extensions.dart';
import '../../constants/app_constants.dart';
import 'button_style.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key? key, this.onPressed}) : super(key: key);
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: TextButton(
        onPressed: onPressed,
        style: buttonStyle(context),
        child: Padding(
          padding: context.paddingLow,
          child: Text(
            AppConstants.tryAgainButtonText,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
