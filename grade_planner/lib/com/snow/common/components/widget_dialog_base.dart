import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogBase extends StatelessWidget {
  final Widget child;

  final Color background;

  const DialogBase({
    super.key,
    required this.child,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      child: Container(
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(28)), color: background),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [child],
          ),
        ),
      ),
    );
  }
}
