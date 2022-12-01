import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/__subject_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/presentation/startscreen/components/widget_row_subject.dart';
import 'package:grade_planner/main.dart';
import 'package:sprintf/sprintf.dart';

import '../../../common/components/widget_two_button_dialog.dart';
import '../../domain/model/subject.dart';
import '../viewAllGrades/screen_viewAllGrades.dart';

class ScreenViewAllSubjects extends StatefulWidget {
  final String title;

  const ScreenViewAllSubjects({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _ScreenViewAllSubjectsState();
}

class _ScreenViewAllSubjectsState extends State<ScreenViewAllSubjects> {
  late Future<Iterable<Subject>> subjects;

  late SubjectUsecases subjectUsecases;

  @override
  void initState() {
    setState(() {
      subjectUsecases = provider.get<SubjectUsecases>();
      subjects = subjectUsecases.getAllSubjects();
    });
  }

  void _reloadData() {
    setState(() {
      subjects = subjectUsecases.getAllSubjects();
    });
  }

  _clickDeleteSubject(Subject subject) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonDialog(
          title: AppLocalizations.of(context)!.confirm_deletion,
          text: sprintf(AppLocalizations.of(context)!.deletion_subject_x_info, [subject.name]),
          positiveLable: "Confirm",
          negativeLable: "Cancel",
          onNegative: () {
            Navigator.of(context).pop();
          },
          onPositive: () {
            subjectUsecases.deleteSubject.call(subject).then((value) {
              _reloadData();
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _clickSubject(Subject subject) async {
    var _ = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ScreenViewAllGrades(
              title: AppLocalizations.of(context)!.add_year,
              subject: subject,
            )));
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              FutureBuilder(
                future: subjects,
                builder: (BuildContext context, AsyncSnapshot shot) {
                  if (shot.hasData) {
                    var subjects = shot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (Subject subject in subjects)
                            SubjectRow(
                              subject: subject,
                              onDelete: _clickDeleteSubject,
                              isOverAverage: subjectUsecases.isOverAverage.callSubject(
                                subject,
                                Settings.getValue("order_mode", defaultValue: 1)!,
                              ),
                              onClick: _clickSubject,
                            )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
