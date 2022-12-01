import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GradeGroupInputSection extends StatelessWidget {
  final ValueChanged<String> onNameChange;
  final ValueChanged<String> onPartChange;

  const GradeGroupInputSection({
    super.key,
    required this.onNameChange,
    required this.onPartChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.group_name)),
            onChanged: onNameChange,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          flex: 1,
          child: TextField(
            decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.percentage_part)),
            onChanged: onPartChange,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        )
      ],
    );
  }
}
