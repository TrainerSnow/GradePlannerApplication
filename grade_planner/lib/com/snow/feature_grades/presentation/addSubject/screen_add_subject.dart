import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grade_planner/com/snow/common/components/widget_error.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/__subject_usecases.dart';

import '../../../../../main.dart';
import '../../domain/util/string_from_response.dart';
import '../addGrade/components/GradeGroupInputSection.dart';

class AddFileScreen extends StatefulWidget {
  AddFileScreen({super.key, required this.title});

  final String title;

  final SubjectUsecases useCases = provider.get<SubjectUsecases>();

  @override
  State<StatefulWidget> createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  /*
    States
   */

  String _subjectName = "";
  int _rowNum = 1;

  final List<int> _groupParts = List.of([-1], growable: true);
  final List<String> _groupNames = List.of([""], growable: true);

  /*
    Events
   */

  _changeGroupPart(int index, int value) {
    if (_groupParts.length > index) {
      _groupParts.removeAt(index);
    }
    _groupParts.insert(index, value);
  }

  _changeGroupName(int index, String value) {
    if (_groupNames.length > index) {
      _groupNames.removeAt(index);
    }
    _groupNames.insert(index, value);
  }

  _changeSubjectName(String name) {
    setState(() {
      _subjectName = name;
    });
  }

  _clickAddGroupRow() {
    setState(() {
      _rowNum++;
      _groupNames.add("");
      _groupParts.add(-1);
    });
  }

  _clickDeleteGroupRow() {
    setState(() {
      if (_rowNum != 1) {
        _rowNum--;
        _groupNames.removeAt(_groupNames.length - 1);
        _groupParts.removeAt(_groupParts.length - 1);
      }
    });
  }

  _clickAddSubject() async {
    var errorMsg = await widget.useCases.checkSubjectInputs.call(_subjectName, _groupParts, _groupNames);

    if (!errorMsg.isOk()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              errorMsg: StringFromResponse.get(context, errorMsg),
              title: AppLocalizations.of(context)!.error,
            );
          });
    } else {
      var groups = <GradeGroup>[for (int i = 0; i < _groupNames.length; i++) GradeGroup(name: _groupNames[i], part: _groupParts[i] / 100, grades: <Grade>[])];

      var now = DateTime.now().millisecondsSinceEpoch;
      widget.useCases.addSubject
          .call(Subject(
        name: _subjectName,
        groups: groups,
        createdAt: now,
        changedAt: now,
      ))
          .then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //If keyboard is enabled
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    var groupSections = <Widget>[];
    for (int i = 0; i < _rowNum; i++) {
      groupSections.add(GradeGroupInputSection(
        onNameChange: (String value) {
          _changeGroupName(i, value);
        },
        onPartChange: (String value) {
          _changeGroupPart(i, int.parse(value));
        },
      ));
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 64,
                ),
                TextField(
                  controller: _controller,
                  onChanged: (String name) {
                    _changeSubjectName(name);
                  },
                  decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.subject_name)),
                ),
                Row(
                  children: [IconButton(onPressed: _clickAddGroupRow, icon: const Icon(Icons.add)), IconButton(onPressed: _clickDeleteGroupRow, icon: const Icon(Icons.delete))],
                ),
                Column(
                  children: groupSections,
                ),
              ],
            ),
          )),
      floatingActionButton: showFab ? FloatingActionButton(onPressed: _clickAddSubject, child: const Icon(Icons.check)) : null,
    );
  }
}
