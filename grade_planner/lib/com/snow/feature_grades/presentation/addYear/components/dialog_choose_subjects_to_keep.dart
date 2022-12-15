import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/components/widget_dialog_base.dart';
import '../../../domain/model/subject.dart';

class DialogChooseSubjectsToKeep extends StatefulWidget {
  final List<Subject> subjects;
  final Function(List<bool>) onApply;

  final String negativeLabel;
  final String posLabel;
  final VoidCallback onCancel;

  const DialogChooseSubjectsToKeep({Key? key, required this.subjects, required this.onApply, required this.negativeLabel, required this.onCancel, required this.posLabel}) : super(key: key);

  @override
  State<DialogChooseSubjectsToKeep> createState() => _DialogChooseSubjectsToKeepState();
}

class _DialogChooseSubjectsToKeepState extends State<DialogChooseSubjectsToKeep> {
  late List<bool> states;

  @override
  void initState() {
    super.initState();
    setState(() {
      states = List.filled(widget.subjects.length, true);
    });
  }

  void _onBoxChange(bool state, int which) {
    setState(() {
      states[which] = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: DialogBase(
        background: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.select_subjects_to_copy,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.select_subjects_to_copy_info, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < widget.subjects.length; i++)
                  ListTile(
                    title: Text(widget.subjects[i].name),
                    leading: Checkbox(
                      value: states[i],
                      onChanged: (bool? value) {
                        _onBoxChange(value ?? false, i);
                      },
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onCancel,
                      child: Text(
                        widget.negativeLabel,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onApply(states);
                      },
                      child: Text(
                        widget.posLabel,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
