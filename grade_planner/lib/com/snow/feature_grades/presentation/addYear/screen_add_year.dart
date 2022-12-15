import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grade_planner/com/snow/di/injecting.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/year.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/util/string_from_response.dart';

import '../../../../../main.dart';
import '../../../common/components/widget_error.dart';
import '../../domain/usecase/__subject_usecases.dart';
import 'components/dialog_choose_existing_year.dart';
import 'components/dialog_choose_subjects_to_keep.dart';

class AddYearScreen extends StatefulWidget {
  AddYearScreen({super.key, required this.title});

  final String title;

  final SubjectUsecases useCases = provider.get<SubjectUsecases>();

  @override
  State<StatefulWidget> createState() => _AddYearScreenState();
}

class _AddYearScreenState extends State<AddYearScreen> {
  late TextEditingController _controller;

  /*
  State values
   */
  String _yearName = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  _clickAddYear() async {
    var year = Year(name: _yearName, subjects: List.empty());
    var result = await widget.useCases.checkYearInput.call(year);

    if (!result.isOk()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMsg: StringFromResponse.get(context, result),
            title: AppLocalizations.of(context)!.error,
          );
        },
      );
    } else {
      widget.useCases.addYear.call(year);
      Navigator.of(context).pop();
    }
  }

  _changeYearName(String value) {
    _yearName = value;
  }

  _clickCopySubjectsFromYear() async {
    var years = (await widget.useCases.getYears());

    if (years.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No Years available to copy the subjects from"),
      ));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogChooseExistingYear(
            years: years,
            onYearSelected: (year) {
              var subjects = year.subjects;

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogChooseSubjectsToKeep(
                      subjects: subjects,
                      onApply: (values) {
                        Navigator.of(context).pop();
                        //TODO: actually copy the subjects
                      },
                      negativeLabel: 'NOPE',
                      onCancel: () {
                        log.wtf("Will pop");
                        Navigator.of(context).pop();
                      },
                      posLabel: 'YAY',
                    );
                  });
            },
          );
        });
  }

  //TODO: translate
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              onChanged: _changeYearName,
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.year_name),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _clickCopySubjectsFromYear, child: const Text("Copy Subjects from other year"))
          ],
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: _clickAddYear,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.add),
            )
          : null,
    );
  }
}
