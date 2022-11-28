import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/__subject_usecases.dart';
import 'package:grade_planner/main.dart';

import '../../../common/components/widget_two_button_dialog.dart';
import '../../domain/model/grade.dart';
import '../startscreen/components/widget_row_grade.dart';
import '../viewAllImages/screen_viewAllImages.dart';

class ScreenViewAllGrades extends StatefulWidget {
  final String title;
  final Subject subject;

  const ScreenViewAllGrades({super.key, required this.title, required this.subject});

  @override
  State<StatefulWidget> createState() => _ViewAllGradesState();
}

class _ViewAllGradesState extends State<ScreenViewAllGrades> {
  late Future<List<Grade>> grades;

  late SubjectUsecases subjectUsecases;

  @override
  void initState() {
    super.initState();
    subjectUsecases = provider.get<SubjectUsecases>();

    _reloadData();
  }

  void _reloadData() async {
    setState(() {
      grades = _getGrades();
    });
  }

  Future<List<Grade>> _getGrades() async {
    var subject = await subjectUsecases.getSubjectByName.call(widget.subject.name);
    var groups = subject.groups;

    var grades = <Grade>[];

    for (GradeGroup group in groups) {
      grades.addAll(group.grades);
    }

    return grades;
  }

  void _clickDeleteGrade(Grade grade) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TwoButtonDialog(
          title: "Confirm Deletion",
          text: "Do you really want to delete the Grade '${grade.name}? Note: This will delete all contained Groups and Grades. You cannot restore this. This deletion is permanent.",
          onNegative: () {
            Navigator.of(context).pop();
          },
          onPositive: () {
            subjectUsecases.deleteGrade.call(grade).then((value) {
              _reloadData();
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  void _clickGrade(Grade grade) async{
    var _ = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenViewAllImages(title: "Images in ${grade.name}", subject: widget.subject, grade: grade,)));
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grades in ${widget.subject.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Grade>>(
          future: grades,
          builder: (BuildContext context, AsyncSnapshot<List<Grade>> shot) {
            if (shot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (Grade grade in shot.data!)
                      GradeRow(
                        grade: grade,
                        onDelete: _clickDeleteGrade,
                        isOverAverage: subjectUsecases.isOverAverage.callGrade(grade, Settings.getValue("order_mode", defaultValue: 1)!),
                        onClick: _clickGrade,
                      )
                  ],
                ),
              );
            }else{
              return const SizedBox(height: 0, width: 0,);
            }
          },
        ),
      ),
    );
  }
}
