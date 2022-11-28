import 'dart:io';

import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_images_for_subject.dart';

class DeleteGrade{
  final SubjectRepository _repository;
  final GetImagesForGrade getImagesForGrade;

  DeleteGrade(this._repository, this.getImagesForGrade);

  Future<void> call(Grade grade)async{
    var subjects = await _repository.getAllSubjects();
    var subject = subjects.firstWhere((element) => element.name == grade.subjectName);
    subjects.remove(subject);

    var group = subject.groups.firstWhere((element) => element.grades.contains(grade));
    subject.groups.remove(group);

    group.grades.remove(grade);

    subject.groups.add(group);

    subjects.add(subject);

    //Deleting images for this grade
    var images = await getImagesForGrade.call(grade, subject);
    for(File image in images){
      image.delete();
    }

    return _repository.updateSubject(subject: subject);
  }
}