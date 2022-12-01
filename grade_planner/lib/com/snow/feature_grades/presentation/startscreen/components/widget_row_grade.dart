import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grade_planner/com/snow/common/util/util_time_format.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:sprintf/sprintf.dart';

class GradeRow extends StatefulWidget {
  final Grade grade;
  final Function(Grade) onDelete;
  final Future<bool> isOverAverage;
  final Function(Grade) onClick;

  const GradeRow({super.key, required this.grade, required this.onDelete, required this.isOverAverage, required this.onClick});

  @override
  State createState() => _GradeRowState();
}

class _GradeRowState extends State<GradeRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails _) { widget.onClick(widget.grade); },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sprintf(
                  AppLocalizations.of(context)!.in_x_x,
                  [
                    widget.grade.subjectName,
                    widget.grade.groupName,
                  ],
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                widget.grade.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      FutureBuilder<bool>(
                        future: widget.isOverAverage,
                        builder: (BuildContext context, AsyncSnapshot shot) {
                          if (shot.hasData) {
                            return Text(
                              widget.grade.value.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: shot.data! ? Colors.green : Colors.red),
                            );
                          } else {
                            return Text(widget.grade.value.toStringAsFixed(1), style: Theme.of(context).textTheme.titleLarge);
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.days_ago,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        TimeFormatUtil.formatMillisDayDuration(DateTime.now().millisecondsSinceEpoch - widget.grade.createdAt),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        widget.onDelete(widget.grade);
                      },
                      icon: const Icon(Icons.delete))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
