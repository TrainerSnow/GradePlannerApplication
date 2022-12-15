import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grade_planner/com/snow/common/components/widget_dialog_base.dart';

import '../../../domain/model/year.dart';

class DialogChooseExistingYear extends StatelessWidget {
  final List<Year> years;
  final Function(Year) onYearSelected;

  const DialogChooseExistingYear({Key? key, required this.years, required this.onYearSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Year? groupValue = years[0];

    return Dialog(
      backgroundColor: Colors.transparent,
      child: DialogBase(
        background: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.select_year,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.select_year_to_copy_subject, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  for (Year year in years)
                    GestureDetector(
                      child: ListTile(
                        title: Text(year.name),
                        leading: Radio<Year>(
                            value: year,
                            groupValue: groupValue,
                            onChanged: (_) {
                              onYearSelected(year);
                            }),
                      ),
                      onTapUp: (_) {
                        onYearSelected(year);
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
