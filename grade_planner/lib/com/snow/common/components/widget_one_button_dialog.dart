import 'package:flutter/material.dart';
import 'package:grade_planner/com/snow/common/components/widget_dialog_base.dart';

class DialogOneButton extends StatelessWidget {
  final String title;
  final String text;
  final String buttonLabel;
  final IconData iconData;
  final VoidCallback onPressed;

  const DialogOneButton({
    Key? key,
    required this.title,
    required this.text,
    required this.buttonLabel,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DialogBase(
        background: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Icon(iconData),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(text, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onPressed,
                  child: Text(
                    buttonLabel,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
