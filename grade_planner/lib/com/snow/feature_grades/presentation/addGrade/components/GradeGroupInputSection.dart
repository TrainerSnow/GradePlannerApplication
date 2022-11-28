import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradeGroupInputSection extends StatelessWidget {

  final ValueChanged<String> onNameChange;
  final ValueChanged<String> onPartChange;

  const GradeGroupInputSection({super.key, required this.onNameChange, required this.onPartChange,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: TextField(
            decoration: const InputDecoration(
                label: Text("Group name")
            ),
            onChanged: onNameChange,
          ),
        ),
        const SizedBox(width: 8,),
        Flexible(
          flex: 1,
          child: TextField(
            decoration: const InputDecoration(
                label: Text("Part")
            ),
            onChanged: onPartChange,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        )
      ],
    );
  }

}