import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
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
        ),
      ),
    );
  }
}
