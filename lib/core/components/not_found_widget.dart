import 'package:flutter/material.dart';
import './/./core/extension/context_extensions.dart';
import '../constants/app_constants.dart';
import 'button_related/try_again_button.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({Key? key, this.onPressed}) : super(key: key);
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: context.highValue * 3.3,
        ),
        Text(
          AppConstants.emptyText,
          style: context.textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: context.lowValue,
        ),
        TryAgainButton(
          onPressed: onPressed,
        ),
      ],
    );
  }
}
