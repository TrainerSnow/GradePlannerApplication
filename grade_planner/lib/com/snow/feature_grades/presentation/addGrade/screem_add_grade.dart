import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/__images_usecases.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/__preferences_usecases.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../main.dart';
import '../../../common/components/widget_error.dart';
import '../../domain/model/subject.dart';
import '../../domain/usecase/__subject_usecases.dart';

class AddGradeScreen extends StatefulWidget {
  AddGradeScreen({super.key, required this.title});

  final String title;

  final SubjectUsecases subUseCases = provider.get<SubjectUsecases>();
  final ImagesUsecases imageUsecases = provider.get<ImagesUsecases>();
  final PreferencesUsecases prefUsecases = provider.get<PreferencesUsecases>();

  @override
  State<StatefulWidget> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  late TextEditingController _gradeNameController;
  late TextEditingController _gradeValueController;

  late List<Subject> subjects;

  String subjectName = "";
  Subject? selectedSubject;

  String _groupName = "";
  GradeGroup? selectedGroup;

  List<GradeGroups>? gradeGroups;
  List<XFile> images = <XFile>[];

  String _gradeName = "";
  double _gradeValue = 0;

  /*
  State values
   */

  @override
  void initState() {
    super.initState();
    _gradeNameController = TextEditingController();
    _gradeValueController = TextEditingController();

    widget.subUseCases.getAllSubjects.call().then((value) => subjects = value);
  }

  void _changeSubjectName(String name) async {
    subjectName = name;
    if (await widget.subUseCases.subjectExists.call(name)) {
      selectedSubject = await widget.subUseCases.getSubjectByName.call(name);
    } else {
      selectedSubject = null;
    }
  }

  void _changeGroupName(String name) {
    _groupName = name;
    if (selectedSubject != null) {
      if (selectedSubject!.groups.map((e) => e.name).contains(name)) {
        selectedGroup = selectedSubject!.groups.firstWhere((element) => element.name == name);
      } else {
        selectedGroup = null;
      }
    }
  }

  void _changeGradeName(String name) {
    _gradeName = name;
  }

  void _changeGradeValue(String value) {
    _gradeValue = double.parse(value);
  }

  void _clickAddPhoto() async {
    if (Platform.isWindows || Platform.isFuchsia || Platform.isMacOS || Platform.isLinux) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(errorMsg: AppLocalizations.of(context)!.add_image_not_supported_info, title: AppLocalizations.of(context)!.error);
        },
      );
    } else {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      setState(() {
        this.images.addAll(images);
      });
    }
  }

  void _clickRemovePhotoFromSelection(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void _clickAddGrade() async {
    var respond = await widget.subUseCases.checkGradeInputs.call(_gradeName, _gradeValue, selectedSubject, selectedGroup);

    if (!respond.isOk()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            errorMsg: respond.title,
            title: AppLocalizations.of(context)!.error,
          );
        },
      );
    } else {
      var grade = Grade(
        value: _gradeValue,
        name: _gradeName,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        groupName: _groupName,
        subjectName: subjectName,
        numPhotos: images.length,
      );

      for (GradeGroup group in selectedSubject!.groups) {
        if (group.name == _groupName) {
          group.grades.add(grade);
        }
      }

      for (int i = 0; i < images.length; i++) {
        var file = images[i];
        widget.imageUsecases.addImage.call(file, "${(await widget.prefUsecases.getPreferences.call()).currentYear}-$subjectName-$_groupName-$_gradeName-$i");
      }

      widget.imageUsecases.deleteCache.call();

      widget.subUseCases.updateSubject.call(selectedSubject!).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) {
                  subjects.map((e) => e.name);
                }
                return subjects.map((e) => e.name).where((element) => element.toLowerCase().contains(value.text.toLowerCase()));
              },
              onSelected: _changeSubjectName,
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: _changeSubjectName,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.subject),
                  ),
                );
              },
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                if (selectedSubject == null) {
                  return [];
                } else {
                  var effectiveSub = selectedSubject as Subject;
                  if (value.text.isEmpty) {
                    return effectiveSub.groups.map((e) => e.name);
                  } else {
                    return effectiveSub.groups.map((e) => e.name).where((element) => element.toLowerCase().contains(value.text.toLowerCase()));
                  }
                }
              },
              onSelected: _changeGroupName,
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: _changeGroupName,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.group),
                  ),
                );
              },
            ),
            TextField(
              controller: _gradeNameController,
              onChanged: _changeGradeName,
              decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.grade_name)),
            ),
            TextField(
              controller: _gradeValueController,
              onChanged: _changeGradeValue,
              decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.grade_value)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _clickAddPhoto,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                ),
                Text(
                  AppLocalizations.of(context)!.add_photo,
                  style: Theme.of(context).textTheme.labelLarge,
                )
              ],
            ),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(images.length, (index) {
                return GestureDetector(
                  onLongPress: () {
                    _clickRemovePhotoFromSelection(index);
                  },
                  child: Image.file(File(images[index].path)),
                );
              }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _clickAddGrade,
        label: Text(AppLocalizations.of(context)!.add),
        icon: const Icon(Icons.send),
      ),
    );
  }
}

class GradeGroups {}
