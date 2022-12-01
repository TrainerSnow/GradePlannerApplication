import 'dart:io';

import 'package:grade_planner/com/snow/feature_grades/domain/model/grade.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/gradegroup.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/subject.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/subject_repository.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/usecase/uc_get_images_for_subject.dart';

class DeleteSubject {
  final SubjectRepository _repository;
  final GetImagesForGrade getImagesForGrade;

  DeleteSubject(this._repository, this.getImagesForGrade);

  Future<void> call(Subject subject) async {
    var groups = subject.groups;
    for (GradeGroup group in groups) {
      var grades = group.grades;

      for (Grade grade in grades) {
        var images = await getImagesForGrade.call(grade, subject);

        for (File image in images) {
          image.delete();
        }
      }
    }

    return _repository.removeSubject(subject: subject);
  }
}
