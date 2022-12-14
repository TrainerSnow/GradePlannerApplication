import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/components/widget_dialog_base.dart';

class ChooseYearDialog extends StatelessWidget {
  final List<String> yearNames;
  final String defaultName;
  final Function(String? name) onChange;
  final Function() onAddClick;

  const ChooseYearDialog({super.key, required this.yearNames, required this.defaultName, required this.onChange, required this.onAddClick});

  @override
  Widget build(BuildContext context) {
    String groupValue = defaultName;
    return Dialog(
      child: DialogBase(
        background: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.select_year,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 16,
            ),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (String name in yearNames)
                  ListTile(
                    title: Text(name),
                    leading: Radio<String>(
                      value: name,
                      groupValue: groupValue,
                      onChanged: onChange,
                    ),
                  )
              ],
            ),
            GestureDetector(
              onTapUp: (TapUpDetails _) {
                onAddClick();
              },
              child: ListTile(
                leading: const Icon(Icons.add),
                title: Text(AppLocalizations.of(context)!.add_year),
              ),
            )
          ],
        ),
      ),
    );
  }
}
