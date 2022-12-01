import 'package:flutter/material.dart';
import 'package:grade_planner/com/snow/common/components/widget_dialog_base.dart';

class TwoButtonDialog extends StatelessWidget {
  final String positiveLable;
  final String negativeLable;

  final String text;
  final String title;

  final Function onPositive;
  final Function onNegative;

  const TwoButtonDialog({
    super.key,
    required this.positiveLable,
    required this.negativeLable,
    required this.text,
    required this.onPositive,
    required this.onNegative,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: DialogBase(
        background: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.question_mark_outlined,
                  size: 24,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              text,
              style: Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    onNegative();
                  },
                  child: Text(
                    negativeLable,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onPositive();
                  },
                  child: Text(
                    positiveLable,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
