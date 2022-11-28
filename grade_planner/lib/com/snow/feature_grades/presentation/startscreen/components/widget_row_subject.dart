import 'package:flutter/material.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';

import '../../../../di/injecting.dart';
import '../../../domain/model/subject.dart';

class SubjectRow extends StatefulWidget {
  final Subject subject;
  final Function(Subject) onDelete;
  final Future<bool> isOverAverage;
  final Function(Subject) onClick;

  const SubjectRow({super.key, required this.subject, required this.onDelete, required this.isOverAverage, required this.onClick});

  @override
  State<StatefulWidget> createState() => _SubjectRowState();
}

class _SubjectRowState extends State<SubjectRow> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
  }

  _toggleExpanded(TapUpDetails _) {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails _) { widget.onClick(widget.subject); },
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subject.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Average",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        FutureBuilder<bool>(
                          future: widget.isOverAverage,
                          builder: (BuildContext context, AsyncSnapshot<bool> shot) {
                            if (shot.hasData) {
                              return Text(
                                widget.subject.average() == double.nan ? "N/A" : widget.subject.average().toStringAsFixed(1),
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: shot.data! ? Colors.green : Colors.red),
                              );
                            } else {
                              return Text(
                                widget.subject.average() == double.nan ? "N/A" : widget.subject.average().toStringAsFixed(1),
                                style: Theme.of(context).textTheme.titleLarge,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Column(children: [
                      Text(
                        "Grades",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        widget.subject.gradesNum().toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ]),
                    Column(children: [
                      Text(
                        "Groups",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        widget.subject.groups.length.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ]),
                  ],
                ),
                if (expanded)
                  Column(
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          for (MapEntry<GradeGroup, double> group in widget.subject.averageByGroup().entries)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "-${group.key.name}: ",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  group.value.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                GestureDetector(
                  onTapUp: _toggleExpanded,
                  child: Text(expanded ? "Show less" : "Show more"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.onDelete(widget.subject);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
