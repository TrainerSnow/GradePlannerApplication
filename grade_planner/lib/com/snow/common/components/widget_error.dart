import 'package:flutter/material.dart';
import 'package:grade_planner/com/snow/common/components/widget_dialog_base.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMsg;
  final String title;

  const ErrorDialog({
    super.key,
    required this.errorMsg,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: DialogBase(
        background: Theme.of(context).colorScheme.errorContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 24,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              errorMsg,
              style: Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
            const SizedBox(
              height: 24,
            ),

          ],
        ),
      )
    );
  }
}
